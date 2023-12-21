########################### Fussed Lasso Simulation ############################
#################### Sta315 Final Project Simulation Study #####################
############################# By: Amrinder Sehmbi ##############################

# Install packages
install.packages("HDPenReg", repos = "https://cran.rstudio.com")

# Load packages
library(HDPenReg)
library(MASS)

# Number of Monte Carlo runs
nMC<-100

# Number of predictors
p<-100

# Sample size
N<-10

# Set rho to generate data matrix X
rho=0.5

# Set mu and sigma to generate data matrix X
mu <- rep(0,p)
Sig <- matrix(rep(0, length(mu)^2), ncol = length(mu))
for (i in 1:length(mu)){
  for(j in 1:length(mu)){
    Sig[i,j] = rho^(abs(i-j))
  }
}

# Set seed
set.seed(N)

### Beta(coefficient) vector
B = rep(0,p)

uniform_length = sample(1:10, 1)

index = sample(1:p - uniform_length, 1)

count = 0
while (index + uniform_length -1 <= p &count < 5){
  coef = rnorm(1, 0 ,1)
  end = index+uniform_length - 1
  B[index:end] = coef
  
  count = count + 1
  index = index + uniform_length
  index = sample(index:p, 1)
}

# Set seed
set.seed(N)
####### Generate Test Set ########
# Data matrix
Xtest = mvrnorm(N, mu, Sig)

# Z matrix (2.5Z∼N(0, 1)
Ztest = matrix(rnorm(N, 0 ,1/(2.5*2.5)), nrow=N)

# Response matrix
Ytest = Xtest %*% B + Ztest






ytest_hat_lasso = matrix(rep(0, nMC*N), ncol = nMC, nrow = N)

ytest_hat_fused_lasso = matrix(rep(0, nMC*N), ncol = nMC, nrow = N)


specificity_lasso = rep(0, nMC)

specificity_fused_lasso = rep(0,nMC)






# Set seed
set.seed(N)

# Run 100 Monte Carlo Simulations

for (run in 1:nMC){
  
  ####### Generate Training Set ########
  # Data matrix
  X = mvrnorm(N, mu, Sig)
  
  # Z matrix (2.5Z∼N(0, 1)
  Z = matrix(rnorm(N, 0 ,1/(2.5*2.5)), nrow=N)
  
  # Response matrix
  Y = X %*% B + Z
  
  ###### Fit Lasso Model ######
  
  lasso_cv =  EMcvlasso(X = X, y = c(Y), lambda = 10:1, nbFolds = 5
                        , intercept = FALSE)
  
  lambda.opt=lasso_cv$lambda.optimal
  
  lasso = EMlasso(X, c(Y), lambda.opt)
  
  lasso_coef = rep(0,p)
  
  for (i in 1:length(lasso[["coefficient"]][[1]])) {
    lasso_coef[lasso[["variable"]][[1]][i]] = lasso[["coefficient"]][[1]][i]
    
  }
  ytest_lasso = c(Xtest %*% lasso_coef + Ztest)
  
  ytest_hat_lasso[,run] <- matrix(ytest_lasso)
  
  
  ###### Fit Fused Lasso Model ######
  
  fused_lasso_cv = EMcvfusedlasso(X = X, y = c(Y), lambda1 = 10:1,
                                  lambda2 = 10:1, nbFolds = 5
                                  , intercept = FALSE)
  
  lambda1.opt=fused_lasso_cv$lambda.optimal[1]
  lambda2.opt=fused_lasso_cv$lambda.optimal[2]
  
  fused_lasso = EMfusedlasso(X, c(Y), lambda1.opt, lambda2.opt)
  
  fused_lasso_coef = fused_lasso$coefficient
  
  ytest_fused_lasso = c(Xtest %*% fused_lasso_coef + Ztest)
  
  ytest_hat_fused_lasso[,run] <- matrix(ytest_fused_lasso)
  
  
  ###### Calculate specificity ######
  count_lasso = 0
  count_fused_lasso = 0
  for (i in 1:p) {
    if (B[i]==lasso_coef[i] & B[i]==0) {
      count_lasso = count_lasso + 1
    }
    if (B[i]==fused_lasso_coef[i] & B[i]==0) {
      count_fused_lasso = count_fused_lasso + 1
    }
  }
  specificity_lasso[run] = count_lasso/p
  specificity_fused_lasso[run] = count_fused_lasso/p
  
}


ytest_hat_mc_lasso <- rep(0,N)

ytest_hat_mc_fused_lasso <- rep(0,N)

#### Estimate response for test set by MC for lasso and fused lasso model #####
for( i in 1:length(ytest_hat_mc_lasso)){
  ytest_hat_mc_lasso[i] <- mean(ytest_hat_lasso[i,])
}

for( i in 1:length(ytest_hat_mc_fused_lasso)){
  ytest_hat_mc_fused_lasso[i] <- mean(ytest_hat_fused_lasso[i,])
}



#### Estimated standard error by MC for prediction of test data set ######
sd(ytest_hat_lasso) / sqrt(nMC)
sd(ytest_hat_fused_lasso) / sqrt(nMC)



##### Estimate specificity by MC for lasso and fused model ######
mean(specificity_lasso)
mean(specificity_fused_lasso)

#### Estimated standard error by MC of specificity of test data set ######
sd(specificity_lasso) / sqrt(nMC)
sd(specificity_fused_lasso) / sqrt(nMC)



##### MSE For Test Set With Lasso #####

sum((Ytest - ytest_hat_mc_lasso)**2) / N



##### MSE For Test Set With Fused Lasso #####

sum((Ytest - ytest_hat_mc_fused_lasso)**2) / N




