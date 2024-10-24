---
editor_options: 
  markdown: 
    wrap: sentence
---



# Statistical Inference

Let's remember our goal of "turning data into information." Based on a sample data set, we want to be able to say something about the larger population of interest or the general phenomena (not just the data you have collected).
If our data is representative of the general population/phenomena, then our sample estimates provide some information but we also need to account for the uncertainty of our estimates due to randomness in the data collection process.
Putting our estimates *in the context of uncertainty & random variability* is called **statistical inference**.
In statistical inference, we care about using sample data to make statements about "truths" in the larger population.

-   To make causal inferences in the sample, we need to account for all possible confounding variables, or we need to randomize the "treatment" and assure there are no other possible reasons for an observed effect.
-   To generalize to a larger population, we need the sample to be representative of the larger population. Ideally, that sample would be randomly drawn from the population. If we actually have a census in that we have data on country, state, or county-level, then we can consider the observed data as a "snapshot in time". There are random processes that govern how things behave over time, and we have just observed one period in time.

Let's do some statistical inference based on a simple random sample (SRS) of 100 flights leaving NYC in 2013.

<div class="reflect">
<p>What is our population of interest? What population could we
generalize to?</p>
</div>



Based on this sample of 100 flights, we can estimate the difference in the mean arrival delay times between flights in the winter compared to the summer.
The fit linear regression model suggests that flights in the winter have on average are about half a minute less delayed than summer flights.
Do you think that is true for all flights?

If we had a different sample of 100 flights, how much different might that estimate be?


``` r
lm.delay <- flights_samp %>%
  with(lm(arr_delay ~ season))

lm.delay %>% 
  tidy()
```

```
## # A tibble: 2 × 5
##   term         estimate std.error statistic p.value
##   <chr>           <dbl>     <dbl>     <dbl>   <dbl>
## 1 (Intercept)     6.69       4.87    1.37     0.172
## 2 seasonwinter   -0.655      6.82   -0.0960   0.924
```

You've had a taste of random variation in Chapter 5 and how that plays a role in the conclusions we can draw.
In this chapter, we will formalize two techniques that we use to do perform statistical inference: confidence intervals and hypothesis tests.
First, we need to formalize the idea of random variation.

## Standard Error

In Chapter 5, we talked about how our estimates might vary if we had a different sample of data.
This random variability could be due to random sampling or randomness if the data values.
In order to get a sense of the uncertainty of our information as it relates to the true population, we need to quantify this variability across potential samples of data.

The tricky piece is that we do not get to observe more than one sample in real life.
We have to imagine all other possible samples without actually observing them.

In Chapter 5, one tool we used was **bootstrapping,** in which we resampled from our sample (with replacement) to mimic the other possible samples.
The variation in the bootstrap estimates could be used.

In Chapter 6, another tool we used was **probability,** in which we use mathematical theory and assumption to help us imagine the other possible samples.
We can estimate the standard deviation of a random variable.
We'll refer to this as the **classical approach** as compared to the **bootstrap approach**.

Using either of these techniques, we can calculate the **standard error (SE)** of a sample estimate which is the estimated standard deviation across all possible random samples.
In other words, the standard error is our best guess of the standard deviation of the sampling distribution, the distribution of sample values across all possible samples of the same size.

### Bootstrap Standard Error Estimate

We started this chapter with a question about arrival delay times in the winter compared to the summer.
Based on one sample of 100 flights, we estimated that in the winter, the delay times are on average about 0.6 minutes less than in the summer.
How certain are we about this number?

Let's resample our sample and quantify our uncertainty through bootstrapping.


``` r
boot_data <- mosaic::do(1000)*( 
    flights_samp %>% # Start with the SAMPLE (not the FULL POPULATION)
      sample_frac(replace = TRUE) %>% # Generate by resampling with replacement
      with(lm(arr_delay ~ season)) # Fit linear model
)


# Bootstrap Standard Error Estimates of coefficients
boot_data %>% 
    summarize(
        se_Intercept = sd(Intercept),
        se_seasonwinter = sd(seasonwinter))
```

```
##   se_Intercept se_seasonwinter
## 1     5.331612        6.781946
```

The standard error for the regression coefficient for `seasonwinter` is 6.8 minutes using the bootstrapping technique.
That tells us that on average, the difference in mean arrival delays between winter and summer could be 6.8 minutes greater or smaller.
Also, this tells us that our sample estimate could be off the true difference in the population by as much as 2\*SE = 2\*6.8 = 13.6 minutes (think back to the 68-95-99.7 Rule).
In the context of the scale of the observed difference (half a minute), we are very uncertain!

If the standard error was 0.1 minutes rather than 6.8 minutes, we'd be much more certain that there is about a half a minute difference in the mean arrival delays between winter and summer.

You'll notice that the code above has exactly the same structure as the bootstrapping code in Chapter 5.
We *calculate the bootstrap standard error by calculating the standard deviation of the bootstrap estimates*.
We ran this code in Chapter 5 to summarize the spread of our bootstrap sampling distribution.
We didn't name it the standard error quite yet.
Also note that every time you run this code, you'll get slightly different estimate of the standard error because bootstrapping is a random process.

Focus on the magnitude of the standard error and consider the number of significant digits of both the estimate and the SE.
If our estimate might be off by almost 15 minutes, we should worry too much about the hundredths of a minute in our estimate.

### Classical Standard Error Estimate

The other tool we can use to get our standard errors is with mathematical theory and probability.
Using probability, we can write out equations to estimate the standard error.
If you are interested in learning about these equations, you should take Mathematical Statistics!

For this class, you just need to know that R knows these equations and calculates the classical standard error for us.

In fact, you've already been looking at them in the output of the fit linear model.
With the tidy output below, look for the column that says `std.error`.
These are the **classical standard errors**.


``` r
lm.delay %>% 
  tidy() #SE for each estimate is in the std.error column
```

```
## # A tibble: 2 × 5
##   term         estimate std.error statistic p.value
##   <chr>           <dbl>     <dbl>     <dbl>   <dbl>
## 1 (Intercept)     6.69       4.87    1.37     0.172
## 2 seasonwinter   -0.655      6.82   -0.0960   0.924
```

You'll notice that for the `seasonwinter` regression coefficient, the equations give a standard error of 6.817 minutes, which when rounded is the same as the rounded bootstrap standard error of 6.8 minutes.

These are two *different* ways of quantifying the random variability and uncertainty in our sample estimates only using ONE observed sample of data.
In practice, we only need to use one of these approaches because they should give us similar values assuming a few conditions hold.

Using either estimate of the standard error, based on the sample data, our best guess is that the mean arrival delays is about 0.6 minutes less in winter than in summer but we might be off by about 13.6 minutes.
So we could say that our best guess at the difference in mean arrival delays is $0.6\pm 13.6$ minutes, which is an interval estimate of the true population value.

<div class="reflect">
<p>How “good” of a guess is the interval estimate? Is the population
value in the interval or not? How might we know?</p>
</div>

## Confidence Intervals

A **confidence interval** (also known as an interval estimate) is an interval of plausible values of the unknown population parameter of interest based on randomly generated sample data.
We construct these intervals in a way so that we can know how "good" of a guess the interval is of the true population parameter value.
The interval computed from one sample may include or contain the true value of the parameter but it may not.

Above, we used the standard error (SE) to create an interval by going up 2 SE's and going down SE's from the estimate.

$$\text{Estimate }\pm 2*SE(\text{Estimate}) = (\text{Estimate} - 2*\text{SE}, \text{Estimate} + 2*\text{SE})$$

### Properties of Confidence Intervals

So, how "good" of a guess is this?
If our sampling distribution is roughly Normal (unimodal, symmetric), then we know that the sample estimate in about 95% of the random samples should be within 2 standard deviations of the true population parameter.

<img src="07-inference_files/figure-html/unnamed-chunk-7-1.png" width="672" style="display: block; margin: auto;" />

You can either trust the mathematical theory or we can simulate the sampling distribution by drawing from our population because in this rare circumstance, we have access to all flights in the population.


``` r
sim_data <- mosaic::do(500)*( 
    flights %>% 
      sample_n(size = 100) %>%  # Generate samples of 100 flights
      with(lm(arr_delay ~ season)) # Fit linear model
)

lines <- sim_data %>%
  summarize(lower = quantile(seasonwinter,0.025),upper = quantile(seasonwinter,0.975),)

sim_data %>%
  ggplot(aes(x = seasonwinter)) + 
  geom_histogram() + 
  geom_vline(data = lines, aes(xintercept=lower), color='red') + 
  geom_vline(data = lines, aes(xintercept=upper), color='red') + 
  labs(x = 'Estimates of seasonwinter',title='Sampling Distribution with lines indicating middle 95%') + 
  theme_classic()
```

<img src="07-inference_files/figure-html/unnamed-chunk-8-1.png" width="672" style="display: block; margin: auto;" />



Based on the simulation of drawing from the population, we see that 95% of the samples have estimated slopes between -19.1 and 13.9.
If we take the population values (center of this distribution) and add and subtract 2 standard deviations, then we get -20.1 and 14.2.

So if we take each 1000 simulated random samples from the population and create an interval estimate by adding and subtracting 2 standard errors (estimates of the standard deviation), we can check to see how often those intervals contain the true population value at the center of the distribution.

Let's look at the confidence intervals for the first 100 random samples from the population.
The dashed line indicates the true population value of the slope coefficient (yes, we are in the rare circumstance in which we have access to the true population).
We've created one line for each interval and colored the according to whether or not the interval covers or contains the true population value.
In the first 100 intervals, we see that 95% of the intervals contain the true population value and 5% do not.
In the 500 random samples generated, close to 95% of them have intervals that contain the true population parameter.
When we get one of these samples, we never know if we are one of the 95% or one of the 5%.

<img src="07-inference_files/figure-html/unnamed-chunk-10-1.png" width="672" style="display: block; margin: auto;" />

```
## # A tibble: 2 × 3
##   SlopeCover     n  prop
##   <chr>      <int> <dbl>
## 1 No            24 0.048
## 2 Yes          476 0.952
```

This makes sense given our **interval construction process**.
If the estimate is within 2 standard errors of the true population parameter (between the dashed lines below), then the interval will contain the true population parameter.
If the estimate is not within 2 standard errors of the true population parameter (outside the dashed lines below), then the interval will NOT contain the true population parameter.

<img src="07-inference_files/figure-html/unnamed-chunk-11-1.png" width="672" style="display: block; margin: auto;" />

### Interval Construction Process

In the intervals we constructed above, we used 95% confidence intervals.
That 95% is the confidence level of the interval estimate.

The **confidence level** represents the proportion of possible random samples and thus confidence intervals that contain the true value of the unknown population parameter.
Typically, the confidence level is abstractly represented by $(1-\alpha)$ such that if $\alpha = 0.05$, then the confidence level is 95% or 0.95.

What is $\alpha$?
We will define $\alpha$ when we get to hypothesis testing, but for now, we will describe $\alpha$ as an error probability.
We want the error probability to be low and we want the confidence level, $(1-\alpha)$, to be high.

We will now formally discuss two ways of creating confidence intervals.
One was have already introduced, which is the classical approach, and the other approach uses bootstrapping.

#### Via Classical Theory

If we can use probability theory to approximate the sampling distribution, then we can create a confidence interval by taking taking our estimate and adding and subtracting a margin of error:

$$\text{Estimate }\pm \text{ Margin of Error}$$

The margin of error is typically constructed using z-scores from the sampling distribution (such as $z^* = 2$ that corresponds to a 95% confidence interval or $\alpha = 0.05$) and an estimate of the standard deviation of the estimate, called a **standard error**.

Once we have an estimate of the standard deviation (through a formula or R output) and an approximate sampling distribution, we can create the interval estimate:

$$\text{Estimate }\pm z^* *SE(\text{Estimate})$$ With linear and logistic regression models, we can have R create the confidence intervals for the slope coefficients.


``` r
# Classical Confidence Interval for Models
confint(lm.delay) #default level is 0.95
```

```
##                   2.5 %   97.5 %
## (Intercept)   -2.967923 16.35568
## seasonwinter -14.183889 12.87457
```

``` r
confint(lm.delay, level = 0.99)
```

```
##                   0.5 %   99.5 %
## (Intercept)   -6.095894 19.48365
## seasonwinter -18.563924 17.25460
```

``` r
confint(lm.delay, level = 0.90)
```

```
##                     5 %     95 %
## (Intercept)   -1.390868 14.77862
## seasonwinter -11.975571 10.66625
```

See code below to find the $z^*$ values for other confidence levels beyond 95% to create the intervals manually.


``` r
alpha <- 0.05 
abs(qnorm(alpha/2)) #z* for 95% CI
```

```
## [1] 1.959964
```

``` r
alpha <- 0.01 
abs(qnorm(alpha/2)) #z* for 99% CI
```

```
## [1] 2.575829
```

``` r
alpha <- 0.1 
abs(qnorm(alpha/2)) #z* for 90% CI
```

```
## [1] 1.644854
```

The fact that confidence intervals can be created as above is rooted in probability theory.
If you would like to see how the form above is derived, see the Math Box below.

<div class="mathbox">
<p>(Optional) Deriving confidence intervals from theory</p>
<p>We know that for a regression coefficient, the sampling distribution
of regression coefficient estimates are approximately Normal and thus
the standardized version is approximately Normal with mean 0 and
standard deviation 1.</p>
<p><span class="math display">\[\frac{\hat{\beta} -
\beta}{SE(\hat{\beta})} \sim \text{Normal}(0,1)\]</span></p>
<p>From there we can write a probability statement using the 68-95-99.7
rule of the normal distribution and rearrange the expression using
algebra:</p>
<p><span class="math display">\[P(-2\leq\frac{\hat{\beta} -
\beta}{SE(\hat{\beta})}\leq2) = 0.95\]</span></p>
<p><span class="math display">\[P(-2 *SE(\hat{\beta})\leq\hat{\beta} -
\beta \leq2 *SE(\hat{\beta}) ) = 0.95\]</span></p>
<p><span class="math display">\[P(-2* SE(\hat{\beta})-\hat{\beta}
\leq  -\beta \leq2 *SE(\hat{\beta})-\hat{\beta} ) = 0.95\]</span></p>
<p><span class="math display">\[P(2 *SE(\hat{\beta})+\hat{\beta} \geq
\beta \geq -2* SE(\hat{\beta})+\hat{\beta} ) = 0.95\]</span></p>
<p><span class="math display">\[P(\hat{\beta}-2 *SE(\hat{\beta}) \leq
\beta \leq\hat{\beta}+2 *SE(\hat{\beta}) ) = 0.95\]</span></p>
<p>You’ve seen the Student T distribution introduced in the previous
chapter. We used the Normal distribution in this derivation, but it
turns out that the Student t distribution is more accurate for linear
regression coefficients (especially if sample size is small). The normal
distribution is appropriate for logistic regression coefficients.</p>
</div>

#### Via Bootstrapping

In order to quantify the sampling variability, we can treat our sample as our "fake population" and generate repeated samples from this "population" using the technique of bootstrapping.

Once we have a distribution of sample statistics based on the generated data sets, we'll create a confidence interval by finding the $\alpha/2$th percentile and the $(1-\alpha/2)$th percentile for our lower and upper bounds.
For example, for a 95% bootstrap confidence interval, $\alpha = 0.05$ and you would find the values that are the 2.5th and 97.5th percentiles.

Let's return to the example of predicting arrival delays as a function of season.
We bootstrapped the data already, but here is the code we used.


``` r
boot_data <- mosaic::do(1000)*( 
    flights_samp %>% # Start with the SAMPLE (not the FULL POPULATION)
      sample_frac(replace = TRUE) %>% # Generate by resampling with replacement
      with(lm(arr_delay ~ season)) # Fit linear model
)
```

Rather than using the classical approach to create confidence intervals, we can find the middle $(1-\alpha)$\*100% (if $\alpha = 0.05$, 95%) of the bootstrap sampling distribution to give us lower and upper bounds for our interval estimate.


``` r
# Bootstrap Confidence Interval
boot_data %>% 
    summarize(
        lb = quantile(seasonwinter, 0.025), # alpha/2
        ub = quantile(seasonwinter, 0.975)) # 1 - alpha/2
```

```
##          lb       ub
## 1 -13.99145 12.32934
```

This interval construction process has the same general properties that the classical approach and the same interpretation, which we'll talk about next.

#### Probability Theory vs. Bootstrapping

In the modern age, computing power allows us to perform bootstrapping easily to create confidence intervals.
Before computing was as powerful as it is today, scientists needed mathematical theory to provide simple formulas for confidence intervals.

If certain assumptions hold, the mathematical theory proves to be just as accurate and less computationally-intensive than bootstrapping.
Many scientists using statistics right now learned the theory because when they learned statistics, computers were not powerful enough to handle techniques such as bootstrapping.

**Why do we teach both the mathematical theory and bootstrapping?** You will encounter both types of techniques in your fields, and you'll need to have an understanding of these techniques until modern computational techniques become more widely used.

### Confidence Interval Interpretation

**So how can and should we talk about these intervals?**

In general, this is what we know about confidence intervals:

-   The estimated interval provides *plausible values* for true population parameter based on our sample data.
-   Assuming the sampling distribution model is accurate, we are 95% confident that our confidence interval of (lower value, upper value) contains the true population parameter.
-   We are confident in the interval construction process because *we expect 95% of samples to lead to intervals that contain the true population parameter value*. We just don't know if our particular interval from our sample contains that true population parameter value or not.
-   It is useful to notice whether a slope of 0 or odds ratio of 1 is a plausible value because these values indicate no differences.

<div class="reflect">
<p>Most importantly, how can we incorporate the data context in our
interpretation?</p>
</div>

For example, let's interpret the bootstrap confidence interval of (-13.9, 12.3) from above; notice how we rounded the lower and upper values so as to not overstate our certainty.

-   Based on a sample of 100 flights from NYC, we estimate that the true mean arrival delays are between 13.9 minutes shorter and 12.3 minutes longer in winter as compared to summer months in NYC. [*Notice the data context*]
-   We created this interval estimate such that we'd expect that 95% of the time, we'd capture the true difference in seasons but we cannot know for sure for this interval. [*Notice how we've written out the population parameter in context*]
-   Additionally, this interval is quite wide (and containing 0) highlighting our uncertainty and direction of the relationship between season and delay times. [*Notice how we are acknowledging the uncertainty in our conclusions*]

### More Examples

To demonstrate code and interpretations, we'll discuss examples of confidence intervals based on a few more models.

#### Linear Regression Model

Using the flight data, how well can the departure delay predict the arrival delay?
What is the effect of departing 1 more minute later?
Does that correspond to 1 minute later in arrival on average?
Let's look at the estimated slope between departure and arrival delays for the sample of 100 flights from NYC.


``` r
lm.delay2 <- flights_samp %>%
  with(lm(arr_delay ~ dep_delay))
       
lm.delay2 %>% 
  tidy()
```

```
## # A tibble: 2 × 5
##   term        estimate std.error statistic  p.value
##   <chr>          <dbl>     <dbl>     <dbl>    <dbl>
## 1 (Intercept)    -2.59    1.86       -1.39 1.66e- 1
## 2 dep_delay       1.00    0.0617     16.3  1.35e-29
```

The classical 95% CI for the slope is given with by


``` r
confint(lm.delay2)
```

```
##                  2.5 %   97.5 %
## (Intercept) -6.2690537 1.094198
## dep_delay    0.8816967 1.126705
```

or with bootstrapping,


``` r
boot_data <- mosaic::do(1000)*( 
    flights_samp %>% # Start with the SAMPLE (not the FULL POPULATION)
      sample_frac(replace = TRUE) %>% # Generate by resampling with replacement
      with(lm(arr_delay ~ dep_delay)) # Fit linear model
)

boot_data %>%
  summarize(
    lower = quantile(dep_delay, 0.025),
    upper = quantile(dep_delay, 0.975))
```

```
##       lower    upper
## 1 0.9259392 1.189972
```

**Interpretation:** If the flight's departure is delayed an additional minute, then I'm 95% confident that we'd expect the arrival delay to be increased by 0.88 to 1.12 minutes, on average.
This makes sense in this context since leaving a minute later on average leads to arriving a minute later give or take tenths of a second.

#### Logistic Regression Model

Are the same proportion of afternoon flights in the winter and the summer?
Let's fit a logistic regression model and see what our sample of 100 flights indicates.


``` r
flights_samp <- flights_samp %>%
  mutate(afternoon = flights_samp$day_hour == 'afternoon')

glm.afternoon <- flights_samp %>%
  with(glm(afternoon ~ season, family = 'binomial'))

glm.afternoon %>% 
  tidy()
```

```
## # A tibble: 2 × 5
##   term         estimate std.error statistic p.value
##   <chr>           <dbl>     <dbl>     <dbl>   <dbl>
## 1 (Intercept)    -0.123     0.286    -0.428   0.668
## 2 seasonwinter    0.479     0.404     1.19    0.235
```

The output for the model gives standard errors for the slopes, so we can create the classical confidence intervals for the slopes first,


``` r
confint(glm.afternoon) #confidence interval for the slope
```

```
##                   2.5 %    97.5 %
## (Intercept)  -0.6905940 0.4389059
## seasonwinter -0.3081988 1.2791414
```

Or with bootstrapping,


``` r
#confidence interval for the slope

boot_data <- mosaic::do(1000)*( 
    flights_samp %>% # Start with the SAMPLE (not the FULL POPULATION)
    sample_frac(replace = TRUE) %>% # Generate by resampling with replacement
    with(glm(afternoon ~ season, family = 'binomial')) # Fit model
)

boot_data %>%
  summarize(
    lower = quantile(seasonwinter, 0.025),
    upper = quantile(seasonwinter, 0.975))
```

```
##        lower   upper
## 1 -0.2719337 1.23918
```

For logistic regression, we exponentiate the slopes to get an more interpretable value, **the odds ratio**.
The tricky thing is that we need to exponentiate after we create the confidence interval for the slope, rather than before.

Here, we are comparing the odds of having a flight in the afternoon between winter months (numerator) and summer months (denominator).
Is 1 in the interval?
If so, what does that tell you?


``` r
confint(glm.afternoon) %>% 
  exp()
```

```
##                  2.5 %   97.5 %
## (Intercept)  0.5012782 1.551009
## seasonwinter 0.7347692 3.593553
```

``` r
boot_data %>%
  summarize(
    lower = quantile(seasonwinter, 0.025),
    upper = quantile(seasonwinter, 0.975)) %>%
  exp()
```

```
##       lower    upper
## 1 0.7619048 3.452783
```

**Interpretation:** Flights from NYC in the winter have about the same odds of being an afternoon flight as compared to the summer time.
I'm 95% confident that the odds of a flight being in the afternoon is between 0.7 and 1.5 times the odds in the summer.
We conclude that we don't have any evidence there any more afternoon flights in the winter versus the summer leaving from NYC.

#### Confidence Intervals for Prediction

Imagine we are on a plane, we left 15 minutes late, how late will arrive?
We've already looked at the slope measuring the relationship, but what about predicting the arrival delay?
Since we only have a sample of 100 flights, we are a bit unsure of our prediction.

A classical CI can give us an interval estimate of what the prediction should be (if we had data on all flights).


``` r
predict(lm.delay2, newdata = data.frame(dep_delay = 15), interval = 'confidence')
```

```
##        fit      lwr      upr
## 1 12.47558 8.881202 16.06996
```

This is taking into account how uncertain we are about our model prediction because our model is based on sample data rather than population data.

**Interpretation:** I'm 95% confident that flights from NYC that left 15 minutes late will arrive on average between 8.9 and 16 minutes.
It is interesting that we estimate the average arrival delay for a flight that left 15 minutes late to be as low as 8.9 minutes suggesting that maybe flights can typically make up time in the air.
We could investigate this by studying the differences in arrival and departure delays.

#### Prediction Intervals

We also know that every flight is different (different length, different weather conditions, etc), so the true arrival delay won't be exactly what we predict.

So to get a better prediction for our arrival delay, we can account for the size of errors or residuals by creating a **prediction interval**.
This interval will be much wider than the confidence interval because it takes into account how far the true values are from the prediction line.


``` r
predict(lm.delay2, newdata = data.frame(dep_delay = 15), interval = 'prediction')
```

```
##        fit       lwr      upr
## 1 12.47558 -22.86868 47.81985
```

You'll notice that the prediction interval is wider than the confidence intervals.
In fact, the prediction interval incorporates information about the standard deviation of residuals to account for the average size of prediction error.
To learn more, take Mathematical Statistics.

**Interpretation:** I predict that 95% of flights from NYC that leave 15 minutes late will arrive on average between 23 minutes early and 48 minutes late.
This is a huge range which suggests that the departure delay is only one factor in determine when a flight arrives at its destination.

## Hypothesis Testing

Hypothesis testing is another tool that can be used for statistical inference.
Let's warm up to the ideas of hypothesis testing by considering two broad types of scientific questions: (1) *Is there* a relationship?
(2) *What* is the relationship?

Suppose that we are thinking about the relationship between housing prices and square footage.
Accounting for sampling variation...

-   ...**is there** a real relationship between price and living area?
-   ...**what** is the real relationship between price and living area?

Whether by mathematical theory or bootstrapping, confidence intervals provide a *range of plausible values* for the true population parameter and allow us to answer both types of questions:

-   **Is there** a real relationship between price and living area?
    -   Is the null value (0 for slopes, 1 for odds ratios) in the interval?
-   **What** is the relationship between price and living area?
    -   Look at the estimate and the values in the interval

**Hypothesis testing** is a general framework for answering questions of the first type.
It is a general framework for making decisions between two "theories".

-   **Example 1**\
    Decide between: true support for a law = 50% vs. true support $\neq$ 50%

-   **Example 2**\
    In the model $\text{Price} = \beta_0 + \beta_1\text{Living Area} + \text{Error}$, decide between $\beta_1 = 0$ and $\beta_1 \neq 0$.

### Hypothesis Test Procedure

#### Hypotheses

In a hypothesis test, we use data to decide between two "hypotheses" about the population.
These hypotheses can be described using mathematical notation and words.

1.  **Null hypothesis** ($H_0$ = "H naught")\

-   A status quo hypothesis
-   In words: there is no effect/relationship/difference.
-   In notation: the population parameter equals a **null value**, such as the slope being zero $H_0: \beta_1 = 0$ or the odds ratio being 1, $H_0: e^{\beta_1} = 1$.
-   Hypothesis that is assumed to be true by default.

2.  **Alternative hypothesis** ($H_A$ or $H_1$)\

-   A non-status quo hypothesis
-   In words: there is an effect/relationship/difference.
-   In notation: the population parameter does not equal a **null value**, $H_A: \beta_1 \neq 0$ or $H_A: e^{\beta_1} \neq 1$.
-   This is typically news worthy.

#### Test statistics

Let's consider an example research question: Is there a relationship between house price and living area?
We can try to answer that with the linear regression model below:

$$E[\text{Price} | \text{Living Area}] = \beta_0 + \beta_1\text{Living Area}$$

We would phrase our null and alternative hypotheses using mathematical notation as follows:

$$H_0: \beta_1 = 0 \qquad \text{vs.} \qquad H_A: \beta_1 \neq 0$$ In words, the null hypothesis $H_0$ describes the situation of "no relationship" because it hypothesizes that the true slope $\beta_1$ is 0.
The alternative hypothesis posits a real relationship: the true population slope $\beta_1$ is not 0.
That is, there is not no relationship.
(*Double negatives!*)

To gather evidence, we collect data and fit a model.
From the model, we can compute a **test statistic**, which tells us how far the observed data is from the null hypothesis.
The test statistic is a *discrepancy measure* where large values indicate higher discrepancy with the null hypothesis, $H_0$.

When we are studying slopes in a linear model, the test statistic is the distance from the null hypothesis value of 0 (the **null value**) in terms of standard errors.
The test statistic for testing one slope coefficient is:

$$T= \text{Test statistic} = \frac{\text{estimate} - \text{null value}}{\text{std. error of estimate}}$$

It looks like a z-score.
It expresses: how far away is our slope estimate from the null value in units of standard error?
With large values (in magnitude) of the test statistic, our data (and our estimate) is discrepant with what the null hypothesis proposes because our estimate is quite far away from the null value in standard error units.
A large test statistic makes us start to doubt the null value.

#### Accounting for Uncertainty

Test statistics are random variables!
Why?
Because they are based on our random sample of data.
Thus, it will be helpful to understand the sampling distributions of test statistics.

What test statistics are we likely to get if $H_0$ is true?
The distribution of the test statistic introduced above "under $H_0$" (that is, if $H_0$ is true) is shown below.
Note that it is centered at 0.
This distribution shows that if indeed the population parameter equals the null value, there is variation in the test statistics we might obtain from random samples, but most test statistics are around zero.

<img src="07-inference_files/figure-html/unnamed-chunk-27-1.png" width="768" style="display: block; margin: auto;" />

It would be very unlikely for us to get a pretty large (extreme) test statistic if indeed $H_0$ were true.
Why?
The density drops rapidly at more extreme values.

How large in magnitude must the test statistic be in order to make a decision between $H_0$ and $H_A$?
We will use another metric called a **p-value**.
This allows us to account for the variability and randomness of our sample data.

**Assuming** $H_0$ is true, we ask: What is the chance of observing a test statistic which is "as or even more extreme" than the one we just saw?
This conditional probability is called a **p-value**, $P(|T| \geq t_{obs} | H_0\text{ is true})$.

If our test statistic is large, then our estimate is quite far away from the null value (in standard error units), and then the chance of observing someone this large or larger (assuming $H_0$ is true) would be very small.
**A large test statistic leads to a small p-value.**

If our test statistic is small, then our estimate is quite close to the null value (in standard error units), and then the chance of observing someone this large or larger (assuming $H_0$ is true) would be very large.
**A small test statistic leads to a large p-value.**

Suppose that our observed test statistic for a slope coefficient is 2.
What test statistics are "as or more extreme"?

-   Absolute value of test statistic is at least 2: $|\text{Test statistic}| \geq 2$
-   In other words: $\text{Test statistic} \geq 2$ or $\text{Test statistic} \leq -2$

The p-value is the area under the curve of the probability density function in those "as or more extreme" regions.

<img src="07-inference_files/figure-html/unnamed-chunk-28-1.png" width="960" style="display: block; margin: auto;" />

Suppose the test statistic for a slope coefficient is -0.5.
This means that the estimated slope is half of a standard error away from 0, which indicates no relationship.
This is not the far and happens quite frequently, about 62% of the time, when the true slope is actually 0.

<img src="07-inference_files/figure-html/unnamed-chunk-29-1.png" width="960" style="display: block; margin: auto;" />

#### Making Decisions

If the p-value is "small", then we reject $H_0$ in favor of $H_A$.
Why?
A small p-value (by definition) says that if the null hypotheses were indeed true, we are unlikely to have seen such an extreme discrepancy measure (test statistic).
We made an assumption that the null is true, and operating under that assumption, we observed something odd and unusual.
This makes us reconsider our null hypothesis.

How small is small enough for a p-value?
We will set a threshold $\alpha$ ahead of time, before looking at the data.
P-values less than this threshold will be "small enough".
When we talk about errors of the decisions associated with rejecting or not rejecting the null hypothesis, the meaning of $\alpha$ will become more clear.

#### Procedure Summary

1.  State hypotheses $H_0$ and $H_A$.
2.  Select $\alpha$, a threshold for what is considered to be a small enough p-value.
3.  Calculate a test statistic.
4.  Calculate the corresponding p-value.
5.  Make a decision:
    -   If p-value $\leq\alpha$, reject $H_0$ in favor of $H_A$.
    -   Otherwise, we fail to reject $H_0$ for lack of evidence.\
        (If this helps to remember: U.S. jurors' decisions are "guilty" and "not guilty". Not "guilty" and "innocent".)

### Hypothesis Testing Errors

Just as with model predictions, we may make errors when doing hypothesis tests.

We may decide to reject $H_0$ when it is actually true.
We may decide to not reject $H_0$ when it is actually false.

We give these two types of errors names.

**Type 1 Error** is when you reject $H_0$ when it is actually true.
This is a false positive because you are concluding there is a real relationship when there is none.
This would happen if one study published that coffee causes cancer in one group of people, but no one else could actually replicate that result since coffee doesn't actually cause cancer.

**Type 2 Error** is when you don't reject $H_0$ when it is actually false.
This is a false negative because you would conclude there is no real relationship when there is a real relationship.
This happens when our sample size is not large enough to detect the real relationship due to the large amount of noise due to sampling variability.

We care about both of these types of errors.
Sometimes we prioritize one over the other.
Based on the framework presented, we control the chance of a Type 1 error through the confidence level/p-value threshold we used.
In fact, the chance of a Type 1 Error is $\alpha$,

$$P(\text{ Type 1 Error }) = P(\text{ Reject }H_0 ~|~H_0\text{ is true} ) =  \alpha$$

Let $\alpha = 0.05$ for a moment.
If the null hypothesis ($H_0$) is actually true, then about 5% of the time, we'd get unusual test statistics due to random sample data.
With those samples, we would incorrectly conclude that there was a real relationship.

The chance of a Type 2 Error is often notated as $\beta$ (but this is not the same value as the slope),

$$P(\text{ Type 2 Error }) = P(\text{ Fail to Reject }H_0 ~|~H_0\text{ is false} ) =  \beta$$

We control the chance of a Type 2 error when choosing the sample size.
With a larger sample size $n$, we will be able to more accurately detect real relationships.
The **power** of a test, the ability to detect real relationships, is $P(\text{Reject }H_0 ~|~H_0\text{ is false}) = 1 - \beta$.
In order to calculate these two probabilities, we'd need to know the value (or at least a good idea) of the true effect.

To recap,

-   If we lower $\alpha$, the threshold we use to determine the p-value is small enough to reject $H_0$, we can reduce the chance of a Type 1 Error.
-   Lowering $\alpha$ makes it harder to reject $H_0$, thus we might have a higher chance of a Type 2 Error.
-   Another way we can increase the power and thus decrease the chance of a Type 2 Error is to increase the sample size.

### Statistical Significance v. Practical Significance

The common underlying question that we ask as Statisticians is "Is there a real relationship in the population?"

We can use confidence intervals or hypothesis testing to help us answer this question.

If we note that the no relationship value is NOT in the confidence interval or the p-value is less then $\alpha$, we can say that there is significant evidence to suggest that there is a real relationship.
We can conclude there is a **statistically significant** relationship because the relationship we observed it is unlikely be due only to sampling variabliliy.

But as we discussed in class, there are two ways you can control the width of a confidence interval.
If we increase the sample size $n$, the standard error decreases and thus decreasing the width of the interval.
If we decrease our confidence level (increase $\alpha$), then we decrease the width of the interval.

A relationship is **practically significant** if the estimated effect is large enough to impact real life decisions.
For example, an Internet company may run a study on website design.
Since data on observed clicks is fairly cheap to obtain, their sample size is 1 million people (!).
With large data sets, we will conclude almost every relationship is statistically significant because the variability will be incredibly small.
That doesn't mean we should always change the website design.
How large of an impact did the size of the font make on user behavior?
That depends on the business model.
On the other hand, in-person human studies are expensive to run and sample sizes tended to be in the 100's.
There may be a true relationship but we can't distinguish the "signal" from the "noise" due to the higher levels of sampling variability.
While we may not always have statistical significance, the estimated effect is important to consider when designing the next study.

Hypothesis tests are useful in determining statistical significance (Answering: "Is there a relationship?").

Confidence intervals are more useful in determining practical significance (Answering: "What is the relationship?")

**Recommended Readings about P-values and Limitations of Hypothesis Testing**:

-   [The ASA Statement on p-Values: Context, Process, and Purpose](https://www.tandfonline.com/doi/full/10.1080/00031305.2016.1154108)
-   [Moving to a World Beyond "p \< 0.05"](https://www.tandfonline.com/doi/full/10.1080/00031305.2019.1583913)
-   [Scientific method: Statistical errors](https://www.nature.com/news/scientific-method-statistical-errors-1.14700)

### Hypotheses involving more than one coefficient {#f-tests}

So far we've considered hypothesis tests involving a *single* regression coefficient.
However, when we are interested in testing whether the relationship between our outcome and *more than one* predictor is *simultaneously* statistically significant, we need a re-frame our hypothesis tests in terms of multiple coefficients.

Suppose, for example, we are interested in the association between the sepal length of an iris and the species type of that iris (setosa, versicolor, or virginica).
We can fit a simple linear regression model with species type as a multi-level categorical predictor, as follows:

$$
E[\text{Sepal.Length} \mid \text{Species}] = \beta_0 + \beta_1 \text{Versicolor} + \beta_2 \text{Virginica}
$$

Note that *neither* $\beta_1$ nor $\beta_2$ alone correspond to the relationship between species type and sepal length!
They correspond to the difference in expected sepal length, comparing each of those species to the reference group (the setosa species) separately.

If species and sepal length were truly unrelated, the null hypothesis would involve both of these coefficients.
We can write our null and alternative hypotheses as:

$$
H_0: \beta_1, \beta_2 = 0 \quad \text{vs.} \quad H_1: \text{At least one of } \beta_1, \beta_2 \neq 0
$$

Here, the null hypothesis described the situation of "no relationship" because it hypothesizes that the differences in outcome between *all* groups defined by out multi-level categorical predictor are truly $0$.
The alternative posits that there is *some* difference in outcome between at least one of the groups.

A null hypothesis where *more than one* coefficient is set equal to zero requires what is referred to as an **F-test**.

#### Nested Models

Nested models are one such case where F-tests can be used to directly compare the larger model and the smaller **nested model**.
If you've removed one or more variables from a model, the result is a smaller nested model.
An example of two models that are nested would be:

$$
E[Y \mid A, B, C] = \beta_0 + \beta_1 A + \beta_2 B + \beta_3 C
$$ and the smaller model

$$
E[Y \mid A] = \beta_0 + \beta_1 A
$$

The F-test that compares the larger model to the smaller model in this case determines whether or not the relationship between $Y$ and *both* $B$ and $C$ is statistically significant, adjusting for $A$.
In symbols, our null and alternative hypotheses comparing these models can be written as

$$
H_0: \beta_2, \beta_3 = 0 \quad \text{vs.} \quad H_A: \text{At least one of }\beta_2, \beta_3 \neq 0
$$

The test statistic for this nested test compares the smaller model to the larger, full model.
For a linear regression model, this is sometimes referred to as a **nested** F-test, and the test statistic is a ratio comparing the sum of squared residuals of either model (F $\sim$ 1 if $H_0$ is true).
For logistic regression, this nested test is called a **likelihood ratio test** and the test statistic is a ratio comparing the likelihood or "goodness" of a model ($\chi \sim 1$ if $H_0$ is true).
The larger the test statistic, the bigger the difference is between the small modeler model and the larger model.

For this reason, F-tests are sometimes used as a metric for doing model selection/comparison.
More details on this application of F-tests are given in Section \@ref(model-selection).

#### F-Tests in R

There are two primary ways to conduct F-tests in R that we will cover in this course.
The first you already know how to do (surprise!), and the second will use the `anova` function.
If you are familiar with the term "Analysis of Variance", you may have heard of the `anova` function already!
In this case, we will use the function primarily because it makes it quite simple to conduct nested F-tests.

Recall our example from above, where we were interested in the relationship between sepal length of irises and species type.
Our null hypothesis was that the coefficients for both the versicolor species, $\beta_1$, *and* the virginica species, $\beta_2$ were equal to zero.
Note that if our null hypothesis is *true*, our linear regression model simplifies to:

$$
\begin{aligned}
E[\text{Sepal.Length} \mid \text{Species}] & = \beta_0 + \beta_1 \text{Versicolor} + \beta_2 \text{Virginica} \\
& = \beta_0 + \beta_1 * 0 + \beta_2 * 0 \\ 
& = \beta_0
\end{aligned}
$$

The above model is sometimes referred to as a "constant-only" or "intercept-only" model.
The summary output from `lm` (or `glm`, if you were doing logistic regression) provides an **overall** F-statistic and corresponding p-value for the hypothesis test where $H_0$ is such that *all regression coefficients* in your model are equal to zero.


``` r
data(iris) 
mod <- lm(data = iris, Sepal.Length ~ Species) 
summary(mod)
```

```
## 
## Call:
## lm(formula = Sepal.Length ~ Species, data = iris)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -1.6880 -0.3285 -0.0060  0.3120  1.3120 
## 
## Coefficients:
##                   Estimate Std. Error t value Pr(>|t|)    
## (Intercept)         5.0060     0.0728  68.762  < 2e-16 ***
## Speciesversicolor   0.9300     0.1030   9.033 8.77e-16 ***
## Speciesvirginica    1.5820     0.1030  15.366  < 2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.5148 on 147 degrees of freedom
## Multiple R-squared:  0.6187,	Adjusted R-squared:  0.6135 
## F-statistic: 119.3 on 2 and 147 DF,  p-value: < 2.2e-16
```

From the output above, the F-statistic is 119.3, with a corresponding p-value $< 2.2 \times 10^{-16}$.
From this hypothesis test, we would conclude that there *is* a statistically significant association between species and sepal length of irises, at a 0.05 significant level.

If the null hypothesis involves more than a single regression coefficient being set to zero, *and* there are additional covariates in our model (such that the "null" model is not an intercept-only model), we need to use the `anova` function in R to conduct our F-test.

**Linear Regression Example:** Below we fit a larger linear regression model of house price using living area, the number of bedrooms, and the number of bathrooms, and compare it to a model of house price using only living area as a predictor:


``` r
homes <- read.delim("http://sites.williams.edu/rdeveaux/files/2014/09/Saratoga.txt")

mod_homes <- homes %>%
  with(lm(Price ~ Living.Area))

mod_homes_full <- homes %>%
  with(lm(Price ~ Living.Area + Bedrooms + Bathrooms))

anova(mod_homes,mod_homes_full)
```

```
## Analysis of Variance Table
## 
## Model 1: Price ~ Living.Area
## Model 2: Price ~ Living.Area + Bedrooms + Bathrooms
##   Res.Df        RSS Df  Sum of Sq      F    Pr(>F)    
## 1   1726 8.2424e+12                                   
## 2   1724 7.8671e+12  2 3.7534e+11 41.126 < 2.2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

Notice that we get the smaller nested model by removing `Bedrooms` and `Bathrooms` from the larger model.
This means that they are nested and can be compared using the nested F-test.

-   What are $H_0$ and $H_A$, in words?
    $H_0$: The number of Bathrooms and Bedrooms does not have an impact on average price after accounting for living area.
    $H_A$: The number of Bathrooms or Bedrooms does have an impact on average price after accounting for living area.

-   What is the test statistic?
    The F = 41.126 is the test statistic.
    Unlike the test for slopes, this test statistic does not have a nice interpretation.
    It seems quite far from 1 (which is what F should be close to if $H_0$ were true), but there are no rules for "how far is far".

-   For a threshold $\alpha = 0.05$, what is the decision regarding $H_0$?
    The p-value of $< 2.2*10^{-16}$ is well below the threshold suggesting that it is very unlikely to have observed a difference between these two models as big as we did if the smaller model were true.
    Thus, we reject $H_0$ in favor of the larger model.

**Logistic Regression Example:** Below we fit a larger logistic regression model of whether a movie made a profit (response) based on whether it is a history, drama, comedy, or a family film, compared to a model with only history as a predictor:


``` r
movies <- read.csv("https://www.dropbox.com/s/73ad25v1epe0vpd/tmdb_movies.csv?dl=1")

mod_movies <- movies %>%
  with(glm( profit ~ History, family = "binomial"))

mod_movies_full <- movies %>%
  with(glm( profit ~ History + Drama + Comedy + Family, family = "binomial"))

anova(mod_movies,mod_movies_full,test='LRT') #test='LRT' is needed for logistic models
```

```
## Analysis of Deviance Table
## 
## Model 1: profit ~ History
## Model 2: profit ~ History + Drama + Comedy + Family
##   Resid. Df Resid. Dev Df Deviance  Pr(>Chi)    
## 1      4801     6630.3                          
## 2      4798     6555.3  3   74.941 3.729e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

Notice that we get the smaller nested model by removing `Drama`, `Comedy`, and `Family` from the larger model.
This means that they are nested and can be compared using the nested test.

-   What are $H_0$ and $H_A$?
    $H_0$: Indicators of Drama, Comedy, and Family do not have an impact on whether a movie makes a profit, after accounting for an indicator of History.
    $H_A$: Indicators of Drama, Comedy, or Family do have an impact on whether a movie makes a profit, after accounting for an indicator of History.

-   What is the test statistic?
    The Deviance = 74.941 is the test statistic.
    Unlike the test for slopes, this test statistic does not have a nice interpretation.
    It seems quite far from 1 (which is it should be close to if $H_0$ were true), but there are no rules for "how far is far".

-   For a threshold $\alpha = 0.05$, what is the decision regarding $H_0$?
    The p-value of $3.729 * 10^{-16}$ is well below the threshold suggesting that it is very unlikely to have observed a difference between these two models as big as we did if the smaller model were true.
    Thus, we reject $H_0$ in favor of the larger model.

## Model Selection

For this class, we will use hypothesis testing primarily as a way to help us decide which variables should be included in an model.
This is referred to as **model selection** or **variable selection**.
We have many tools that can help us make these decisions.
We'll first discuss two types of hypothesis tests that are useful for model selection and explain another hypothesis test that is automatically completed when you fit a model.
Finally, we summarize all of the model selection tools you have at your disposal that we've covered in this class and point to other tools that you may learn in future courses.

### Testing Individual Slopes

A major emphasis of our course is regression models.
It turns out that many scientific questions of interest can be framed using regression models.

In the `tidy()` output, R performs the following hypothesis tests by default (for every slope coefficient $\beta_j$):

$$H_0: \beta_j = 0 \qquad \text{vs} \qquad H_A: \beta_j \neq 0$$ The test statistic is equal to the slope estimate divided by the standard error.

$$t_{obs} = \text{Test statistic} = \frac{\text{estimate} - \text{null value}}{\text{std. error of estimate}} = \frac{\text{estimate} - 0}{\text{std. error of estimate}} $$

**Linear Regression Example:** Below we fit a linear regression model of house price on living area:


``` r
mod_homes <- homes %>%
  with(lm(Price ~ Living.Area))

mod_homes %>% tidy()
```

```
## # A tibble: 2 × 5
##   term        estimate std.error statistic   p.value
##   <chr>          <dbl>     <dbl>     <dbl>     <dbl>
## 1 (Intercept)   13439.   4992.        2.69 7.17e-  3
## 2 Living.Area     113.      2.68     42.2  9.49e-268
```

The `statistic` column is the test statistic equal to `estimate/std.error`, and the `p.value` column is the p-value.

-   What are $H_0$ and $H_A$?\
    We write the model $E[\text{Price}|\text{Living Area} ] = \beta_0 + \beta_1\text{Living Area}$.\
    $H_0: \beta_1 = 0$ (There is no relationship between price and living area.)\
    $H_A: \beta_1 \neq 0$ (There is a relationship between price and living area.)

-   What is the test statistic?
    We see that the estimated slope for Living Area is 42 standard errors away from the null value of 0, which makes us start to doubt the null hypothesis of no relationship.

-   For a threshold $\alpha = 0.05$, what is the decision regarding $H_0$?\
    Note that when you see `e` in R output, this means "10 to the power".
    So `9.486240e-268` means $9.49 \times 10^{-268}$, which is practically 0.
    This p-value is far less than our threshold $\alpha = 0.05$, so we reject $H_0$ and say that we have strong evidence to support a relationship between price and living area.

Is this consistent with conclusions from a confidence interval?


``` r
confint(mod_homes)
```

```
##                 2.5 %     97.5 %
## (Intercept) 3647.6958 23231.0922
## Living.Area  107.8616   118.3835
```

The interval does not include 0 so we conclude that 0 is not supported as a plausible value for the average increase in price for every 1 square foot increase in living area size of a house, based on the observed sample data.

**Logistic Regression Example:** Below we fit a logistic regression model of whether a movie made a profit (response) on whether it is a history film:


``` r
mod_movies <- movies %>%
  with(glm( profit ~ History, family = "binomial"))
mod_movies %>%
  tidy()
```

```
## # A tibble: 2 × 5
##   term        estimate std.error statistic     p.value
##   <chr>          <dbl>     <dbl>     <dbl>       <dbl>
## 1 (Intercept)   0.152     0.0296     5.15  0.000000258
## 2 HistoryTRUE   0.0207    0.146      0.142 0.887
```

The `statistic` column is the test statistic equal to `estimate/std.error`, and the `p.value` column is the p-value.
Note that if we test the slope, we can make conclusions about the odds ratios because $e^0 = 1$.

Try yourself!

-   What are $H_0$ and $H_A$?
-   What is the test statistic?
-   For a threshold $\alpha = 0.05$, what is the decision regarding $H_0$?
-   Is this consistent with the confidence interval?


``` r
confint(mod_movies)
```

```
##                   2.5 %    97.5 %
## (Intercept)  0.09438169 0.2102419
## HistoryTRUE -0.26484980 0.3085225
```

ANSWER:

-   What are $H_0$ and $H_A$?\
    We write the model $\log(Odds(\text{Profit}|\text{History})) = \beta_0 + \beta_1\text{HistoryTRUE}$.\
    $H_0: \beta_1 = 0$ (There is no relationship between odds of profit and whether a movie is a history file.)\
    $H_A: \beta_1 \neq 0$ (There is a relationship between odds of profit and whether a movie is a history file.)

-   What is the test statistic?
    We see that the estimate slope for HistoryTRUE is 0.14 standard errors away from 0.
    This is not the far so we don't have much evidence against the null hypothesis that history films are not more or less profitable than other films.

-   For a threshold $\alpha = 0.05$, what is the decision regarding $H_0$?\
    The p-value is 0.88, which is quite large and greater than our threshold $\alpha = 0.05$, so we fail to reject $H_0$ because it is quite likely to see an observed difference in estimated log odds of making a profit if history were not more or less likely to be profitable.

-   Is this consistent with the confidence interval?
    Yes, the 95% confidence interval includes and in fact straddles 0, which suggests we are quite uncertain as to the true relationship between categorizing a film as a history film and the likelihood of it being profitable.

#### Suggested Actions

You might be wondering how to use the information gained by testing individual slopes to see if they are far from zero, taking into account the uncertainty in our estimates.

If the value of a slope coefficient in the population is truly 0, *after accounting for the other variables in the model*, then it plays no role in the model.
If we get a small test statistic and thus a large p-value, it suggests that *we try to remove that slope* and corresponding variable from the model and compare models because we do not have enough evidence to say that the slope is far from 0, *after accounting for the other variables in the model*.

Notice, we say *try* to remove the variable.
We do not say *eliminate* the variable from all models going forward because there are many reasons why a variable might have a slope of 0.

-   A variable may not have any bearing or relationship with the outcome and thus the slope is practically 0. In these circumstances, you generally should remove it from the model because we want a simpler model with fewer variables.
-   A variable may have a weak relationship with the outcome, even *after accounting for the other variables in the model*, but if the sample size is small, there is so much uncertainty that we can't ascertain that it is different from 0. You'll need to decide whether or not it is important to include based on the context and causal inference arguments.
-   If two explanatory variables are highly correlated but can explain a lot of the variability in the outcome, they both have a slope near 0 because *after accounting for the other variable in the model*, it can't add much. Try to remove one of the variables and see how the slope estimates change.
-   Two category levels in a categorical variable may not be that different (slope which measure the difference may be 0). You can try to combine categories that are similar, if it makes sense in the data context, or acknowledge the information gained about how those groups are not different, *after accounting for the other variable in the model*.

### Nested Tests

If you've removed one or more variables from a model, the result is a smaller nested model.
We can directly compare the larger model and the smaller **nested model** (from removing 1 or more variables from the larger model) using an F-test.
Determining whether or not the addition of variables is statistically significant is one way to do model comparison.
Details on F-tests can be found in Section \@ref(f-tests).

#### Suggested Actions

You might be wondering how to use the information gained by comparing a smaller nested model to a larger model.

-   If the p-value is large, then you don't have evidence to support the larger model.
-   If the p-value is small, then you need to look back at the variables you removed.

This tool is particularly helpful if you have a categorical variable with three or more categories as you can test all of the slopes for that one variable at once.

This tools can also be helpful to stop you from removing too many variables at once.

In practice, you can iterate between testing individual slopes to determine which variables to consider removing and then comparing nested models.
Also, you'll incorporate other model selection tools in your process, not just these two types of hypothesis tests.

### Summary of Model Selection Methods

In general, we want a simple model that works well.
We want to follow Occam's Razor, a philosophy that suggests that it is a good principle to explain the phenomena by the simplest hypothesis possible.
In our case, that mean the fewest variables in our models.

#### Linear Regression Tools

-   Exploratory visualizations give us an indication for which variables have the strongest relationship with our response of interest (also if it is not linear)
-   $R^2$ can tell us the percent of variation in our response that is explained by the model -- We want HIGH $R^2$
-   The standard deviation of the residuals, $s_e$ (residual standard error), tells us the average magnitude of our residuals (prediction errors for our data set) -- We want LOW $s_e$

With the addition of statistical inference in our tool set, we now have many other ways to help guide our decision making process.

-   Confidence intervals or tests for individual coefficients or slopes ($H_0: \beta_k = 0$, population slope for kth variable is 0 meaning no relationship)
    -   See `tidy(lm1)`
-   Nested tests for a subset of coefficients or slopes ($H_0: \beta_k = 0$, population slope for kth variable is 0 meaning no relationship)
    -   `anova(lm1, lm2)` for comparing two linear regression models (one larger model and one model with some variables removed)

So there are model selection criteria that we can use that penalizes you for having too many variables.
Here are some below.

-   Choose a model with a higher adjusted $R^2$, calculated as, $$R^2_{adj} = 1 - \frac{SSE/(n-k-1)}{SSTO/(n-1)}$$ where $k$ is the number of estimated coefficients in the model.
    -   Find the adjusted R squared in the output of `glance(lm1)`

#### Logistic Regression Tools

-   Exploratory visualizations give us an indication for which variables have the strongest relationship with our response of interest (also if it is not linear)\
-   We want HIGH accuracy and LOW false positive and false negative rates that can separate predicted probabilities fairly well between the true outcome groups.

With the addition of statistical inference in our tool set, we now have many other ways to help guide our decision making process.

-   Confidence intervals or tests for individual coefficients or slopes ($H_0: \beta_k = 0$, population slope for kth variable is 0 meaning no relationship)
    -   See `tidy(lm1)`
-   Nested tests for a subset of coefficients or slopes ($H_0: \beta_k = 0$, population slope for kth variable is 0 meaning no relationship)
    -   `anova(glm1, glm2, test = 'LRT')` for comparing two logistic regression models (one larger model and one model with some variables removed)

So there are model selection criteria that we can use that penalizes you for having too many variables.
Here are some below that you'll see in future classes.

-   Choose a model with a LOWER Akaike Information Criterion (AIC) and Bayesian Information Criterion (BIC) calculated as

$$AIC = -2\log(L) + 2(k+1)$$ $$BIC= -2\log(L) + (k+1)\log(n)$$\
- Calculated using `BIC(glm1)` and `AIC(glm1)`

#### Prediction Tools

Here is a taste of Statistical Machine Learning:

If our goal is prediction, then we will want to choose a model that has the lowest prediction error.
BUT, if we fit our model to our data and then calculate the prediction error from that SAME data, we aren't getting an accurate estimate of the prediction error because we are cheating.
We aren't doing predictions for new data values.

**Training and Testing**

In order to be able to predict for new data, we can randomly split our observed data into two groups, a **training** set and a **testing** set (also known as a validation or hold-out set).

-   Fit the model to the training set and do prediction on the observations in the testing set.
-   The prediction Mean Squared Error, $\frac{1}{n}\sum(y_i - \hat{y}_i)^2$ can be calulated based on the predictions from the testing set.

**Drawbacks of Validation Testing**

-   

    1)  The MSE can be highly variable as it depends on how you randomly split the data.

-   

    2)  We aren't fully utilizing all of our data to fit the model; therefore, we will tend to overestimate the prediction error.

**K-Fold Cross-Validation**

If we have a small data set and we want to fully use all of the data in our training, we can do **K-Fold Cross-Validation**.
The steps are as follows:

-   Randomly splitting the set of observations into $k$ groups, or folds, of about equal size.

-   The first group is treated as the test set and the method or model is fit on the remaining $k-1$ groups.
    The MSE is calculated on the observations in the test set.

-   Repeat $k$ times; each group is treated as the test set once.

-   The k-fold CV estimate of MSE is an average of these values, $$CV_{(k)} = \frac{1}{k}\sum^k_{i=1}MSE_i $$ where $MSE_i$ is the MSE based on the $i$th group as the test group.
    In practice, one performs k-fold CV with $k=5$ or $k=10$ as it reduces the computational time and it also is more accurate.


``` r
require(boot)
cv.err <- cv.glm(data,glm1, K = 5)
sqrt(cv.err$delta[1]) #out of sample average prediction error
```

##Chapter 7 Major Takeaways
