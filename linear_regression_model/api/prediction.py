# prediction.py

from fastapi import FastAPI
from pydantic import BaseModel, Field
import pandas as pd
import joblib
import numpy as np
import sys
import os


# Load model, scaler, and feature names safely

try:
    model = joblib.load("best_model.pkl")
    scaler = joblib.load("scaler.pkl")
    feature_names = joblib.load("feature_names.pkl")
except Exception as e:
    print(f"Failed to load model/scaler/features: {e}", file=sys.stderr)
    # Raise the exception so Render logs the failure
    raise e


# Initialize FastAPI

app = FastAPI(
    title="Student Housing Rent Predictor",
    description="Predicts apartment rent prices based on features like bathrooms, bedrooms, size, and property attributes.",
    version="1.0"
)


# Define API input model

class RentInput(BaseModel):
    bathrooms: float = Field(None, ge=0, le=20, description="Number of bathrooms")
    bedrooms: float = Field(None, ge=0, le=20, description="Number of bedrooms")
    square_feet: float = Field(None, ge=100, le=10000, description="Size in square feet")
    latitude: float = Field(None, description="Latitude of property")
    longitude: float = Field(None, description="Longitude of property")
    
    category: str = Field(..., description="Property category: home or short_term")
    price_type: str = Field(..., description="Price type: Monthly, Weekly")
    has_photo: str = Field(..., description="Photo availability: Thumbnail or Yes")
    pets_allowed: str = Field(..., description="Pets allowed: Cats,Dogs, Dogs, Unknown")


# Helper: encode categorical features

def encode_categorical(input_data: dict) -> pd.DataFrame:
    # Initialize all expected features with zeros
    encoded = {col: 0 for col in feature_names if col != 'price'}

    # Fill numeric features
    numeric_features = ['bathrooms', 'bedrooms', 'square_feet', 'latitude', 'longitude']
    for feature in numeric_features:
        if feature in encoded:
            encoded[feature] = input_data.get(feature, 0)

    # Map categorical input to one-hot columns
    mapping = {
        'category': f"category_housing/rent/{input_data['category']}",
        'price_type': f"price_type_{input_data['price_type']}",
        'has_photo': f"has_photo_{input_data['has_photo']}",
        'pets_allowed': f"pets_allowed_{input_data['pets_allowed']}"
    }

    for key, col in mapping.items():
        if col in encoded:
            encoded[col] = 1

    return pd.DataFrame([encoded])


# Prediction endpoint

@app.post("/predict")
def predict_rent(data: RentInput):
    try:
        input_dict = data.dict()

        # Fix missing or invalid numeric values
        input_dict['bathrooms'] = input_dict['bathrooms'] if input_dict['bathrooms'] and input_dict['bathrooms'] > 0 else 1
        input_dict['bedrooms'] = input_dict['bedrooms'] if input_dict['bedrooms'] and input_dict['bedrooms'] > 0 else 1
        input_dict['square_feet'] = input_dict['square_feet'] if input_dict['square_feet'] and input_dict['square_feet'] > 0 else 500
        input_dict['latitude'] = input_dict['latitude'] if input_dict['latitude'] is not None else 0.0
        input_dict['longitude'] = input_dict['longitude'] if input_dict['longitude'] is not None else 0.0

        # Encode features
        input_df = encode_categorical(input_dict)

        # Scale features
        scaled_df = scaler.transform(input_df)

        # Predict
        prediction = model.predict(scaled_df)

        return {
            "predicted_rent": float(prediction[0]),
            "note": "Quantitative values were fixed if missing or invalid"
        }

    except Exception as e:
        return {"error": str(e)}


# Root endpoint

@app.get("/")
def root():
    return {
        "message": "Welcome to the Student Housing Rent Prediction API. Use /predict with POST request to get predictions."
    }


# Optional: Run locally

if __name__ == "__main__":
    import uvicorn
    port = int(os.environ.get("PORT", 8000))  # Render sets $PORT automatically
    uvicorn.run("prediction:app", host="0.0.0.0", port=port)
