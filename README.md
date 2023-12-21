# Fussed Lasso Simulation Study

## Date

April 2022

## Project Summary

### Project Overview:

- Implemented the Fused Lasso model for optimizing contract negotiation in procurement.
- Inspired by Tibshirani and Saunders' article on "Sparsity and Smoothness via the Fused Lasso."
- Addressed the limitations of Lasso by introducing the Fused Lasso, designed for features with meaningful ordering.

### Motivation:

- Applied the Fused Lasso to analyze a prostate cancer dataset with naturally ordered features.
- Procured blood serum data representing intensity for various time-of-flight values, aiming to predict cancer presence.
- Focused on 48,538 mass-to-charge (𝑚/𝑧) sites with 157 healthy patients and 167 patients with cancer.

### Defining the Fused Lasso:

- Formulated the prediction problem with 𝑁 samples, response 𝑌, and features 𝑥𝑖𝑗.
- Addressed cases where the number of features 𝑝 is much greater than the sample size 𝑁.
- Introduced the Fused Lasso model, penalizing both coefficients and their successive differences for sparsity.

### Computation:

- Utilized computational methods including fixed bounds and a search strategy for solving the Fused Lasso.
- Employed the Sparse Quadratic Optimizer (SQOPT) for efficient solution of quadratic programming problems.
- Applied a search strategy leveraging the least angle regressions (LARS) algorithm for large datasets.

### Advantages:

- Demonstrated superior performance of the Fused Lasso when 𝑝 ≫ 𝑁 through a mini-simulation.
- Highlighted the Fused Lasso's effectiveness in cases where features have a meaningful order.
- Emphasized the sparsity benefits of the Fused Lasso in terms of coefficients and their differences.

### Disadvantages:

- Addressed challenges in scenarios with unordered features, requiring estimation of feature orders.
- Noted potential runtime limitations, especially with increasing dataset dimensions, impacting practicality.

### Simulation Study:

- Conducted a Monte Carlo simulation comparing the predictive performance of Lasso and Fused Lasso.
- Observed Fused Lasso's improved test error compared to Lasso, with specificity considerations.
- Highlighted the Fused Lasso's performance in cases where the number of predictors significantly exceeds the sample size.

### Conclusion:

- Concluded that the Fused Lasso excels when 𝑝 ≫ 𝑁, offering improved predictive performance over Lasso.
- Acknowledged trade-offs, such as increased runtime and sensitivity to feature ordering, in different scenarios.

## File Description

README.md: Project description

The-Fussed-Lasso-Report.pdf: Final report including analysis and results

The-Fussed-Lasso-Simulation.R: R(programiing language) code for the monte carlo simulation of the fused lasso model

## Tools and Technologies

R, Rstudio HDPenReg, MASS

## Author

Amrinder Sehmbi

amrindersehmbi@outlook.com
