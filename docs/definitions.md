
```
## 
## Attaching package: 'dplyr'
```

```
## The following objects are masked from 'package:stats':
## 
##     filter, lag
```

```
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

```
## Registered S3 method overwritten by 'mosaic':
##   method                           from   
##   fortify.SpatialPolygonsDataFrame ggplot2
```

```
## 
## The 'mosaic' package masks several functions from core packages in order to add 
## additional features.  The original behavior of these functions should not be affected by this.
```

```
## 
## Attaching package: 'mosaic'
```

```
## The following object is masked from 'package:Matrix':
## 
##     mean
```

```
## The following object is masked from 'package:ggplot2':
## 
##     stat
```

```
## The following objects are masked from 'package:dplyr':
## 
##     count, do, tally
```

```
## The following objects are masked from 'package:infer':
## 
##     prop_test, t_test
```

```
## The following objects are masked from 'package:stats':
## 
##     binom.test, cor, cor.test, cov, fivenum, IQR, median, prop.test,
##     quantile, sd, t.test, var
```

```
## The following objects are masked from 'package:base':
## 
##     max, mean, min, prod, range, sample, sum
```

# Definitions

This section attempts to have a list of terms and definitions for each chapter. It may not be complete, quite yet. 

## Chapter 1

**Categorical Variable**: A characteristic with values that are names of categories.

**Census**: The process of collecting data on every individual or subject in a population of interest.

**Cluster Sampling**: Sometimes a sampling frame is more readily available for clusters of units rather than the units themselves.

**Confounding Variables**: A third variable that is a common cause for the “treatment” and the “response”.

**Context of Data**: Who is in the data set, what is being measured, where were they collected, when were they collected, why were they collected, and who collected the data and for what purpose.

**Convenience Sampling**: Individuals that make up a convenience sample are easy to contact or to reach and are often systematically different from the population of interest.

**Correlation Coefficient**: A measure of strength of a linear relationship calculated as the (almost) average of products of the z-scores.

**Data**: Anything that contains information (e.g. images, text, spreadsheets).

**Ethics**: The norms or standards for conduct that distinguish between right and wrong. 

**Experiment**: Data is collected in such a way such that the researcher does manipulate or intervene in characteristics of the individuals by randomly assigning individuals to treatment or control groups.

**Item Nonresponse Bias**: When individuals who answer some but don’t answer other questions are systematically different than those that do in their responses.

**Measurement error**: Technologies that measure variables of interest may not always be accurate and human calibration of those instruments may be off as well.

**Observational Study**: Data is collected in such a way such that the researcher does not manipulate or intervene in the characteristics of the individuals.

**Population of Interest**: A group of individuals or subjects that we would like to know information about. 

**Quantitative Variable**: A characteristic with measured numerical values with units.

**Random Sampling**: Each unit in the sampling frame has a known, nonzero probability of being selected, and the sampling is performed with some chance device (e.g. coin flipping, random number generation).

**Recall bias**: People often unintentionally make mistakes in remembering details about the past. If the study design is retrospective in that it requires units to rely on their memory, we may get bias in the information collected.

**Representative sample**: The subset of the population we have collected data on has similar characteristics that we are interested in collecting to the population of interest. 

**Response bias/Self-report bias/Social desirability bias**: Bias occurs when the recorded response does not accurately represent the true value for the individual due to wording of the question, ordering of the questions, format of response, or to increase social desirability. 

**Sample**: A subset of the population of interest selected for data collection.

**Sampling Bias**: This occurs when our sample is unrepresentative of the population of interest due to systematic bias in the sampling procedure.

**Sampling Frame**: This is the complete list of individuals/units in the population of interest.

**Self-Selection and Volunteer Sampling**: Individuals that make up this type of sample self-select or volunteer to be in a sample and are ofte systematically different from the population of interest.

**Simple Random Sampling**: Each unit in the sampling frame has the same chance of being chosen and individuals are selected without replacement (once they have been chosen, they cannot be chosen again). With this strategy, every sample of a given size is equally likely to arise.

**Stratified Sampling**: The units in the sampling frame are first divided into categories/strata (e.g. age categories). Simple random sampling is then performed within each category/stratum. 

**Tidy Data**: Data in a rectangular table where rows correspond to observations and columns correspond to variables.

**Undercoverage**: This is a form of sampling bias that happens when some groups of the population are inadequately represented in the sample due to the sampling procedure.

**Unit Nonresponse Bias**: When those individuals who are selected but choose to not participate are systematically different than those that do.

**Variable**: A characteristic or measurement recorded in a tidy data set.

## Chapter 2

**Bar plot**: A graph of multiple rectangles where the height shows the counts or proportion of observations within each category of one categorical variable; the width of the rectangles is arbitrary and does not encoded data.

**Boxplot**: An alternative graphical summary for a quantitative variable that consists of the box (25th to 75th percentile), the line in the box (median), the tails or whiskers (to the most extreme observed values within 1.5\*IQR), and points (outliers that are further than 1.5\*IQR from the box)  

**Center of a Distribution**: The typical value which could be measured with the mode, mean, or median. 

**Conditional distribution**: The relative frequencies within subsets, typically calculated based on a two-way table for two categorical variables.

**Direction**: Indicating whether a relationship is positive, negative, or neutral

**Distribution**: The way something is spread out (the way in which values vary).

**Form**: The type of relationship we observe (linear, curved, none)

**Frequency**: The count of observations

**Histogram**: A graph to show the distribution of a quantitative variable. The x-axis is a number line that is divided into intervals called bins. The height of the bars shows either the frequency within intervals (counts of units that fall into that bin/interval) or the density (fraction of units that fall into that bin/interval). Gaps between bars are meaningful. They indicate absence of values within an interval.

**Interquartile Range**: 75th percentile - 25th percentile

**Marginal Distribution**: If you are looking at the numerical summary of two categorical variables, the marginal distribution is the relative frequency of one of the variables, ignoring the other. 

**Mean**: The average value calculated as the sum of values divided by the total number of values.

**Median**: The middle value if you ordered all of the values. 

**Mode**: A “peak”/“bump” in the distribution.

**Mosaic plot**: A graph of rectangles where the relative height of the bars shows the conditional distribution (relative frequency within subsets), and the width of the bars shows the marginal distribution (relative frequency of the X variable, ignoring the other variable).

**Outlier**: A point far from the rest of the observations

**Relative Frequency**: The count of observations divide by the total number of observations

**Scatterplot**: With two quantitative variables, the graphical display with points reflecting the pair of values on a coordinate plane. 

**Shape**: When describing a distribution of a quantitative variable, you should comment on whether it is symmetric or skewed and how many modes it has. 

**Side-by-side bar plot**: A graph of many rectangles where the height shows the count of the categories within groups in the data (for two categorical variables). The rectangles are typically colored according to the grouping categorical variable. 

**Simpson’s Paradox**: A situation in which you come to two different conclusions if you look at results overall versus within subsets.

**Skewed Left**: A distribution is left-skewed if there is a long left tail.

**Skewed Right**: A distribution is right-skewed if it has a long right tail.

**Spread (or variation)**: The measure of how much the values vary. Are the values concentrated around one or more values or spread out?

**Stacked bar plot**: A graph of rectangles where the height of the entire bar shows the marginal distribution (frequency of the X variable, ignoring the other variable), and the relative heights within one rectangle show conditional distributions (frequencies within subsets).

**Stacked bar plot based on proportions**: A graph of rectangles where the relative heights within one rectangle show conditional distributions (frequencies within subsets).

**Standard deviation**: Root mean squared deviations from mean

**Strength**: The compactness of points around the average relationship.

**Symmetric Distribution**: A distribution is symmetric if you fold it in half and the sides match up.

**Trimmed means**: Drop the lowest and highest k% and take the mean of the rest.

**Variance**: Square of the standard deviation

**Z-score**:  A standardized value that gives the number of standard deviation a value is from the mean.

## Chapter 3

**Bootstrapping**: The process of resampling from our sample to estimate the variability in the estimated slope coefficients and to provide an interval estimate of plausible values for the slope coefficient. 

**Explanatory or Predictor Variable**: The independent variable that we may use to predict the outcome or response variable.

**Extrapolation**: Making predictions by plugging in values of the explanatory variables that are beyond the observed range; requires assuming the relationship captured in the model will continue outside the observed range.

**Indicator Variable**: A variable that has two values (0 or 1) that indicate whether a subject or individual has that characteristic or is in the group. It is used primarily to allow cateogrical variables to be included in regression (linear or logistic) models. If there are K categories in a categorical variable, we only need K-1 indicator variables to be included in the model. 

**Interaction Term**: An interaction term is the product of two variables and it allows for effect modification, which is when one variable can modify the effect or slope of another variable on the response variable. 

**Ladder of Powers**: A tool to organize power transformations ($x^{power}$) from higher powers down to lower powers but when power = 0, we use the natural log function (In R: `log()`).

**Least Squares**: The estimation technique that involves minimizing the sum of squared residuals to find the best fitting "line". 

**Leverage**: An observation that has leverage is far from the rest in terms of an explanatory variable may have the power to change the placement of the line because it also has a large residual value. 

**Multiple Linear Regression**: A linear regression model with more than one explanatory variable included in the model. 

**Outcome or Response Variable**: The dependent variable that we hope to predict based on explanatory variables.

**Predicted or Fitted Values**: The predicted responses for the observed data based on a model.


**Residual**: The observed outcome value minus the predicted value from a model. 

**R Squared**: Without any data context: The percent of variation in Y that can be explained by the fit model.

**Sensitivity Analysis**:

**Simple Linear Model**: A regression model that assumes a straight relationship between one explanatory variable and a response variable.

**Slope Interpretation in Simple Linear Model**: Without any data context: For a 1 unit increase in X, we'd expect a $b_1$ increase in the predicted Y. To put in data context: make sure you know the units of your variable and what is a meaningful "1 unit" to describe. 

**Slope Interpretation in Multiple Linear Model**: If there are no interaction terms: For a 1 unit increase in $X_j$, we'd expect a $b_j$ increase in the predicted Y, keeping all other variables fixed. If there are interaction terms: write out the model for subgroups to determine interpretation.

**Standard deviation of the Residuals**: The variability or spread of the residuals around its mean of 0, indicating the average magnitude of a residual or prediction error (in R: it is called the residual standard error).

**Transformations**: If there is a non-linear relationship between a quantitative explanatory variable and a response variable, we can try to transform one or both of the variables to make the relationship more like a straight line. If there is unequal spread in the response around the curved relationship, try transforming the response variable first. Then use the ladder of powers and Tukey's circle to guide your trial and error of finding the transformations that result in a relationship closest to a straight line with equal spread around it. 

## Chapter 4

**AIC/BIC**: The AIC and BIC are information criteria that can be used to compare models, where we want a model with a lower AIC or BIC. 

**False Positive Rate**: The relative frequency of predicting the event would happen, given that the event didn't happen (count of false positives/count of times event did not actually happen).

**False Negative Rate**: The relative frequency of predicting the event wouldn't happen, given that the event did happen (count of false negatives/count of times event did actually happen).

**Logistic Regression**: A model that is used to predict a binary categorical variable (only has two outcomes).

**Odds**: The chance of an event divided by the chance the event does not happen. 

**Odds Ratio**: A ratio of odds an event will happen, comparing between two subgroups. 

**Sensitivity**: The relative frequency of predicting the event would happen, given that the event did happen (count of true positives/count of times event did actually happen).

**Specificity**: The relative frequency of predicting the event would not happen, given that the event did not happen (count of true negatives/count of times event did not actually happen).

**Slope Interpretation in Logistic Regression Model**: If there are no interaction terms: For a 1 unit increase in X, we'd expect the estimated odds of an event to change by a multiplicative factor of $e^{b_j}$, keeping all other variables fixed. If there are interaction terms: write out the model for subgroups to determine interpretation.

## Chapter 5

**Bootstrapping**: The process of resampling our sample mimics the process of sampling from the full target population using our best stand-in for the population: our sample. We bootstrap our sample in order to 1) estimate the variability of the statistic and 2) get a range of plausible values for the true population parameter.


**Null Hypothesis**: A hypothesis that is conservative/not interesting/does not elicit action, typically of the form "there is no real relationship" or "there is no real difference."

**Parameter**: A numerical summary of population that is typically unknown but of interest 

**Randomization Variability**: If we could repeat the randomization process (to a treatment group) in an experiment, each treatment group would be slightly different and thus the numerical summaries of those groups would vary as well. 

**Randomization Test**: Assume no real difference between treatment groups (null hypothesis). Then randomly shuffle the treatment groups to repeat the randomization process under the assumption of no real relationship. Repeat and see how big of a difference we'd expect under the null hypothesis and compare with what difference was actually observed. 

**Sampling Distribution**: The distribution of values of a sample statistic across all possible random samples from the population (has a center, spread, and shape).

**Sampling Variability**: If we could repeat the random sampling process, each sample we would get would be slightly different and thus the numerical summaries or statistics of that sample would vary as well.

**Simulating Randomization into Groups**: Since we cannot repeat the entire experiment, we can simulate the randomization into groups and utilize the observed data by assuming the treatment has no real impact on the outcome. We can estimate the variability in the group differences under this assumption. 

**Simulating Sampling from a Population**: If we had the population, we would simulate many possible random samples and estimate the variability in the sample statistics across random samples. 

**Statistic**: Any numerical summary of sample data

## Chapter 6

**Bayes Rule**: This rule provides us a way to find the conditional probability of A given B when we know the chance of B given A and the chance of A. Used in disease testing...

**Bernoulli Trials**: If a random process satisfies the following three conditions, then we can use the Bernoulli Model to understand its long-run behavior: 1. Two possible outcomes (success or failure) 2. Independent “trials” (the outcome for one unit does not depend on the outcome for any other unit). 3/ P(success) =  p is constant (the relative frequency of success in the population that we are drawing from is constant).

**Binomial Model**: Imagine we had a sample of $n$ individuals from the population. Then we are considering  $n$ independent Bernoulli “trials”. If we let the random variable $X$ be the count of the number of successes in a sample of size $n$, then $X$ follows a Binomial Model. 

**Central Limit Theorem**: The Central Limit Theorem (CLT) tells us that with a “sufficiently large” sample size, the sampling distribution of the sample mean based on a simple random sample is normally-distributed with mean equal to the population mean and variance equal to the population variance divided by $n$. 

**Conditional Probability**: The chance that A occurs given that event B occurs is equal to the probability of the joint event (A and B) divided by the probability of B. Given that  B happened, we focus on the subset of outcomes in the sample space in which B occurs and then figure out what the chance of A happening within that subset.

**Disjoint**: Two events are disjoint if A occuring prevents B from occurring (they both can’t happen at the same time).

**Empirical Probability**:  If you could repeat a random process over and over again (physically or simulating with a computer), you’d get a sense of the possible outcomes and their associated probabilities by calculating their relative frequency in the long run. When we talk about "according to your simulation," we are referring to empirical probabilities. 

**Estimate**: An informed guess based on available data. 

**Event**: A subset of outcomes of a random process.

**Expected Value**: The expected value of a random variable is the long run average value of a random variable, calculated as the weighted sum of the values, weighted by the chances of them happening. 

**Independent**: A and  B are independent events if  B occurring doesn’t change the probability of A occurring.

**Normal Model**: A model for a continuous random variable that has a symmetric and unimodal probability density function defined by mean $\mu$ and standard deviation $\sigma$. 

**Probability Model**: A list of values and associated probabilities of a random variable. 

**Probability Mass Function**: A function that gives the probability of a discrete random variable such that you can plug in the value and get the probability of that value. 

**Probability Density Function**: A function that gives the probability of a continuous random variable such that the total area under the curve is 1 and the area under the curve for a particular interval gives the probability of the random variable being in that interval of values. 

**Random Process**: Any process/event whose outcome is governed by chance. It is any process/event that cannot be known with certainty. 

**Random Variable**: A variable whose outcome (the value it takes) is governed by chance.

**Sample Space**: The set of all possible outcomes of a random process.

**Subjective Probability**: When you use a number between 0 and 1 (100%) to reflect your uncertainty in an outcome (rather than based on empirical evidence or mathematical theory). We are generally not talking about this type of probability in this class. 

**Student's T Model**: For small sample sizes, this model is appropriate for a z-score when you need to estimate the population standard deviation using the sample standard deviation. 

**Theoretical Probability**: If you don’t have time to repeat a random process over and over again, you could calculate probabilities based on mathematical theory and assumptions. When we talk about "according to theory," we are referring to theoretical probability.

**Variance**: The variance of a random variable is a measure of the variability or spread of a random variable. Intuitively it gives you the expected squared deviation from the long-run average. 

## Chapter 7

**AIC**: Akaike Information Criterion can be used to select a model by choosing a model with the lowest AIC; it is a measure of the sum of squared residuals plus a penalty of 2 times the number of coefficients in the model. 

**Adjusted R Squared**: A modified R squared measure that takes into accoun the number of estimated coefficients in the model; note that it does not give you the percent of variation explained, but would be a better choice for using to choose a model as it doesn't necessarily stay constant or increase with the additional of another variable. It can decrease when adding variables that don't contribute to the explaining the variation in the outcome. 

**Alternative Hypothesis**: A claim being made about the population. A non-status quo hypothesis: hypothesis of an effect/relationship/difference.

**BIC**: Bayesian Information Criterion can be used to select a model by choosing a model with the lowest BIC; it is a measure of the sum of squared residuals plus a penalty of $log(n)$ times the number of coefficients in the model. This has a greater penalty than AIC, thus it favors a smaller model than AIC. 

**Bootstrap Confidence Interval**: To create a $(1-\alpha)*100\%$ confidence intervals, you find the $\alpha/2$th and $1-\alpha/2$th percentiles of the bootstrap distribution. This process has known mathematical properties such that in about 95% of the random samples, the constructed interval will contain the true population parameter. 

**Classical Confidence Interval**: To create a $(1-\alpha)*100\%$ confidence intervals, you add and subtract the margin of error, typically calculated as a scaled standard error of the estimate. The amount that we scale the standard error depends on the shape of the sampling distribution; if it is Normal, then we typically add and subtract 2 standard errors. This process has known mathematical properties such that in about $(1-\alpha)*100\%$ of the random samples, the constructed interval will contain the true population parameter. 

**Confidence Interval**: An interval of plausible values strategically created using a process with known mathematical properties. 

**Confidence Level**: $(1-\alpha)*100\%$ is the confidence level; so if $\alpha = 0.05$, then we have a 95% confidence about the process. It indicates the proportion of random samples in which we'd expect the interval to contain the true population parameter. 

**Cross Validation**: To avoid overfitting our model to the observed data such that we can't get good predictions for new data points, we consider fitting the model on a subset of the data, called a training set, and then predict on a testing set. With cross-validation, we allow each data point to be in the testing set once and continue to fit the model on the training set and predicting on the test set and average the sum of squared predicting errors across different test sets. 

**Hypothesis Testing**: The process of comparing observed data from a sample to a null hypothesis about a population. The goal is to put the observed statistic in the context of the distribution of statistics that could happen due to chance (random sampling or randomization to treatment group), if the null hypothesis (no difference or no relationship) were actually true. If it were very unlikely to observe our statistic when the null hypothesis is true, we have strong evidence to reject that hypothesis. Otherwise, we do not have enough evidence to reject the null hypothesis. 

**Model Selection**: In practice, you need to decide which explanatory variables should be included in an model. We have a variety of tools to help us choose: visualizations, R squared, standard deviation of residuals, confidence intervals and hypothesis tests for slope coefficients, nested tests for a subset of slope coefficients, information criteria, cross-validation, etc. 

**Null Hypothesis**: Hypothesis that is assumed to be true by default. A status quo hypothesis: hypothesis of no effect/relationship/difference.


**Practically Significant**: A relationship or difference is practically significant if the estimated effect is large enough to impact real life decisions. This effect may or may not be statistically significant depending on the sample size and variability in the sample.   

**Prediction Intervals**: An interval used to indicate uncertainty in our predictions. This interval not only incorporates the uncertainty in our estimates of the population parameters but also the variability in the data. 

**P-value**: Assuming the null hypothesis is true, the chance of observing a test statistic as or more extreme than then one we just saw. 

**Standard Error**: The estimated standard deviation of a sample statistic. 

**Statistical Inference**: The process of making general statements about population parameters using sample data; typically in the form of confidence intervals and hypothesis testing.

**Statistically Significant**:  We can conclude there is a statistically significant relationship because the relationship we observed is unlikely to occur when consider sampling variabliliy under the null hypothesis. How unlikely? We typically determine a relationship is statistically significant if the p-value is less than a threshold $\alpha$, chosen ahead of time. This may or may not be practically significant. For example, if we have a large sample size, we may have statistical significance but not practical significance.

**Test Statistic**: The test statistic is a numerical summary of the sample data that measures the discrepancy between the observed data and the null hypothesis where large values indicate higher discrepancy. 

**Type 1 Error**: A Type 1 error happens when you reject the null hypothesis when it is actually true. The probability of this happening is $\alpha$, if you use $\alpha$ as a threshold to determine how small the p-value needs to be to reject the null hypothesis.

**Type 2 Error**: A Type 2 error happens when you fail to reject the null hypothesis when it is actually false. The probability of this happening requires know the value of the true effect. 

