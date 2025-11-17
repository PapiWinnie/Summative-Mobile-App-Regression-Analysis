# Student Housing Rent Predictor

## Mission
My mission is to simplify the process of finding student housing in Rwanda by predicting apartment rental prices. By providing reliable estimates, I aim to help students make informed decisions and assist at least 200 students by 2027.


## Dataset
Since there is no public dataset for student housing in Rwanda, I used a rich Kaggle dataset: **`apartments_for_rent_classified_10K.csv`**. This dataset contains 10,000 apartment listings with features like bedrooms, bathrooms, square footage, location, and property attributes, providing enough volume and variety to train regression models effectively.

**Key Features Used:**
- **Numeric:** `bathrooms`, `bedrooms`, `square_feet`, `latitude`, `longitude`
- **Categorical:** `category`, `price_type`, `has_photo`, `pets_allowed`

**Visualizations:**

1. **Correlation Heatmap**  
   Shows which features strongly correlate with rent.  
   ![Correlation Heatmap](images/correlation_heatmap.png)

2. **Bedrooms vs Rent Scatter Plot**  
   Visualizes how rental prices vary with the number of bedrooms.  
   ![Scatter Plot](images/bedrooms_vs_rent.png)


## Models
I implemented multiple regression models to predict rental prices:

1. **Gradient Descent Linear Regression** – optimized iteratively by minimizing loss.  
2. **Linear Regression (scikit-learn)** – standard least-squares method.  
3. **Decision Tree Regressor** – captures nonlinear patterns in the data.  
4. **Random Forest Regressor** – ensemble method that improves accuracy and reduces overfitting.

The **Random Forest Regressor** performed best (lowest MSE). I saved this model as `best_model.pkl`, along with `scaler.pkl` and `feature_names.pkl` for deployment.

**Prediction Flow:**
- Flutter frontend sends JSON input to the API.
- API validates and scales numeric features, encodes categorical features.
- Scaled input is passed to the trained model.
- API returns predicted rent.


## API Endpoint
The API is publicly available and tested with Swagger UI:

**POST** `https://summative-mobile-app-regression-analysis.onrender.com/predict`

**Example Input:**

{
  "bathrooms": 2,
  "bedrooms": 3,
  "square_feet": 850,
  "latitude": 1.9579,
  "longitude": 30.1127,
  "category": "home",
  "price_type": "Monthly",
  "has_photo": "Yes",
  "pets_allowed": "Dogs"
}


**Example Output:**

{
  "predicted_rent": 450.0,
  "note": "Quantitative values were fixed if missing or invalid"
}


**Swagger UI:** `https://summative-mobile-app-regression-analysis.onrender.com/docs`


## Flutter Mobile App

### Installation

1. Clone the repository:

git clone <your-repo-url>
cd <project-folder>


2. Install dependencies:


flutter pub get


3. Run the app on an emulator or device:


flutter run


### Features Implemented

* Input fields for all model variables.
* **Predict** button to trigger API call.
* Display area shows predicted rent or error messages if inputs are invalid.
* Organized and user-friendly layout.

**Example Screenshot:**
![App Screenshot](images/flutter_app_screenshot.png)


## Demo Video

[YouTube Demo – 5 Minutes](https://youtu.be/<your-video-id>)

* Demonstrates the mobile app making predictions and API Swagger UI tests.
* Shows model creation, training, and performance evaluation (MSE for Linear Regression, Decision Tree, and Random Forest).
* Explains why Random Forest was selected based on dataset characteristics and model performance.



