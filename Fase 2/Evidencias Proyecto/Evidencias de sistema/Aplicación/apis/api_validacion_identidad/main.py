from typing import Union
from fastapi import FastAPI
from pydantic import BaseModel
import face_recognition
import numpy as np
import os

app = FastAPI()


class PhotosFiles(BaseModel):
    id_card_photo: str
    face_photo: str


@app.get("/")
def status():
    return {"status-api": "run"}


@app.post("/comparation_idcard_face")
def comparation_idcard_face(images: PhotosFiles):
    try:
        threshold: float = 0.5
        img_folder = "/face-img/"
        print(f"{images.id_card_photo} vs {images.face_photo}")

        # Validar que las imágenes existan
        if not validate_imagenes(f"{img_folder}{images.id_card_photo}"):
            return {"status": False, "message": "The ID card photo does not exist.", "data": None}
        if not validate_imagenes(f"{img_folder}{images.face_photo}"):
            return {"status": False, "message": "The face photo does not exist.", "data": None}

        # Cargar las imágenes
        image1 = face_recognition.load_image_file(f"{img_folder}{images.id_card_photo}")
        image2 = face_recognition.load_image_file(f"{img_folder}{images.face_photo}")

        # Extraer las características faciales (embeddings)
        face_encoding1 = face_recognition.face_encodings(image1)
        face_encoding2 = face_recognition.face_encodings(image2)

        # Asegurarse de que ambas imágenes tengan un rostro detectado
        if len(face_encoding1) == 0 or len(face_encoding2) == 0:
            return {"status": False, "message": "No faces were detected in one or both images", "data": None}

        # Usamos el primer rostro detectado en cada imagen
        face_encoding1 = face_encoding1[0]
        face_encoding2 = face_encoding2[0]

        # Calcular la distancia de los embeddings (distancia euclidiana)
        face_distance = np.linalg.norm(face_encoding1 - face_encoding2)
        print(f"Distancia entre los embeddings: {face_distance}")

        # Determinar si la distancia está por debajo del umbral (0.6 por defecto)
        print(f"threshold: {threshold}")
        print(f"face_distance de umbral: {face_distance}")
        print(f"face_distance < threshold: {face_distance} < {threshold}")
        is_same_person = face_distance < threshold

        # Calcular el porcentaje de similitud (a menor distancia, mayor similitud)
        similarity_percentage = (1 - face_distance) * 100
        print(f"Porcentaje de similitud calculado: {similarity_percentage:.2f}%")

        # Resultado final
        if is_same_person:
            return {"status": True, "message": "The photos are of the same person.", 
                    "data": {"similarity_percentage": similarity_percentage, "face_distance": face_distance,"threshold": threshold}
                    }
        else:
            return {"status": True, "message": "The photos are NOT of the same person.", 
                    "data": {"similarity_percentage": similarity_percentage, "face_distance": face_distance,"threshold": threshold}
                    }
    except Exception as e:
        return {"status": False, "message": str(e), "data": None}
    

def validate_imagenes(img):
    if os.path.isfile(img):
        return True
    return False
