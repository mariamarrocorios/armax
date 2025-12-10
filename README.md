# ARMAX Model for Forecasting Water Consumption in Pigs

This repository contains a **pre-trained ARMAX model** to forecast water consumption (in mL/pig/hour) based on time series and environmental variables such as temperature and ammonia levels.

The original training dataset is **private and not included**, but this repository allows you to use the model with **your own data**.

------------------------------------------------------------------------

## Contents

-   `trained_armax_model.RData` – The saved ARMAX model trained on internal data.
-   `predict_with_model.R` – R script to load the model and generate forecasts using new user-provided data.
-   `README.md` – This file.

------------------------------------------------------------------------

## Requirements

Make sure the following R packages are installed:

``` r
install.packages(c("forecast", "dplyr"))
```

## Input Format

You must provide a `.csv` file (e.g., `your_data.csv`) with **at least the following columns**:

| Column name   | Description                    |
|---------------|--------------------------------|
| `Temperature` | External temperature (numeric) |
| `NH3`         | Ammonia levels (numeric)       |
| `N_days`      | Day index (e.g., 1, 2, 3…)     |

The script automatically generates harmonic regressors (sine/cosine waves) using the row index (assuming hourly data).

## How to Use the Model

1.  Clone this repository or download the files.
2.  Place your own CSV file (e.g., `your_data.csv`) in the same directory.
3.  Open R and run the following script:

``` r
source("predict_with_model.R")
```

4.  After running the script:

-   A forecast plot will be shown.
-   A CSV file named `predictions_output.csv` will be created with predicted values and 95% confidence intervals.

## Output Format

The model outputs a CSV file named `predictions_output.csv` containing the forecasted water consumption values along with their 95% confidence intervals. The file has the following columns:

| Column     | Description                                    |
|------------|------------------------------------------------|
| Prediction | The predicted water consumption value          |
| Lower_95   | The lower bound of the 95% confidence interval |
| Upper_95   | The upper bound of the 95% confidence interval |

This output can be used for further analysis or visualization.

## Notes

-   Ensure your input CSV file includes all required columns: `Temperature`, `NH3`, and `N_days`.
-   The model assumes data is clean and free of missing values in these columns.
-   The confidence intervals are calculated based on the model's residual variance.
-   For best results, use recent and accurate environmental data.

## License

This project uses a custom-trained model. The data that support the findings of this study are available from Grupo Vall Companys but restrictions apply to the availability of these data, which were used under license for the current study, and so are not publicly available. Data are however available from the authors upon reasonable request and with permission of Grupo Vall Companys.

## Contact

If you have questions or feedback, feel free to reach out to:

**Beatriz Garcia**

- **Email:** [beatriz.garciam@irta.cat](mailto:beatriz.garciam@irta.cat)

**Maria Marroco**

- **Email:** [maria.marroco@irta.cat](mailto:maria.marroco@irta.cat)  
- **GitHub:** [mariamarrocorios](https://github.com/mariamarrocorios)