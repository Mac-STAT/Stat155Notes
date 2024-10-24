





# Visualizing Data

The first step in any data analysis is to visually explore your data. 

There is a saying that "a picture is worth a 1000 words." In making visualizations, our goal is to quickly and easily get a better understanding of the variability, structure, and relationships that exist in the data. 

Here we will cover the standard appropriate graphics for univariate variation and bivariate relationships. We will also cover techniques for multivariate relationships (3 or more variables). The choice of the graphic depends on the type(s) of variable(s): quantitative or categorical. Thus, the first step in creating a graphic is to think about the variables that you are interested in visualizing and determining whether they are quantitative or categorical.

For each type of variable, we use a real dataset to illustrate the visualizations.

## Good Visualization Principles

Before we discuss the standard graphics, let's lay out the basic design principles for good data visualizations.

1. **Show the data:** This may be self-explanatory, but make sure that the data is the focus and driver of the visualization. 

2. **Avoid distorting the data:** Avoid 3D charts as the added dimension distorts the comparison. The area in a graph should equal the magnitude of the data it is representing.

3. **Simplify:** In 1983, Edward Tufte said that "A large share of ink on a graphic should present data-information, the ink changing as the data change. Data-ink is the non-erasable core of a graphic, the non-redundant ink arranged in response to variation in the numbers represented." Remove any unnecessary "ink" that does not assist in the presentation of the data. Remove distractions.

4. **Facilitate comparisons:** In order to explain variation, we want the graphics to facilitate comparisons between groups. The design should make it easier to compare between groups rather than harder. 

5. **Use contrast:** Humans have developed to seek out visual contrast. When choosing colors and annotation, strive for more contrast in luminance (white to dark) to make it easier for everyone to visually perceive. 

6. **Use color appropriately:** Think about your audience. A small proportion of the population is color-blind; try printing it in grayscale to see if the color palette is still effective. Also, every culture has different associations with colors; ask others for feedback on color choices. Neuroscience research has shown that humans are more sensitive to red and yellow, so those are good colors to use for highlighting key points. 

7. **Annotate appropriately:** Informative text is crucial for providing data context. Make sure to use informative axis labels and titles. It may be worth adding text to explain extreme outliers.

For examples of good data visualizations in the news and discussion around them, check out the New York Times column ["What's Going on in This Graph?"](https://www.nytimes.com/column/whats-going-on-in-this-graph).

## Brief Intro to R

Throughout this class, we use R and RStudio to visualize, analyze, and model real data. To straighten out which is which: [R](https://cran.r-project.org/) is the name of the language itself (syntax, words, etc.) and [RStudio](https://www.rstudio.com/) is a convenient software interface that you'll interact with on the computer.

While you'll be learning about and using R throughout the course, this is not a course on R. Our focus will be on data and statistical modelling. We will be using R and RStudio as tools to help us get information from data. 

### Basic Syntax

For this class, we will have data that we want to pass to a function that performs a particular operation (does something cool) on our data. Thus, we'll pass **inputs** as arguments to a **function**:


``` r
FunctionName(argument1 = a1, argument2 = a2,..., argumentk = ak)
```

Note the `FunctionName` and the use of parantheses. Inside the parantheses, the argument name (`argument1`) goes first and the value you are passing as an input is after = (`a1`). 


We may want to save the **output** of the function by assigning it a name using the assignment operator, `<-`:


``` r
OutputName <- FunctionName(argument1 = a1, argument2 = a2,..., argumentk = ak)
```


R allows us to be lazy and not include the argument name as long as we provide the input in the correct order:


``` r
OutputName <- FunctionName(a1, a2,..., ak)
```

We can also **nest** functions by first performing one operation and then passing that as an input into another function. In the code below, `Function1()` would first run with the input `data` and create some output that is then passed as the first input in `Function2()`. So R evaluates functions from the inside-out. 


``` r
Function2(Function1(data))
```

As we go through real examples below, notice the names of the functions that we use. The name comes right before `(` and the inputs we pass in right after `(`. 

Additionally, we are going to use a shortcut that makes our code more readable. It is called a **pipe** and looks like `%>%`. What this does is pass the output on its left as the first argument to the function on the right. The following two sections of code do exactly the same thing but the second is easier to read. For this code, we take data and summarize the variable height and then take the mean of the heights. 


``` r
summarize(data, mean(height))

data %>%
  summarize(mean(height))
```

There is so much more we could say about functions in R, but we will stop here for now. 


With this in mind, we'll point to external references if you'd like to go deeper in your understanding of R as a programming language throughout this class. 

To get a broad sense of R, you can work through R primers (https://rstudio.cloud/learn/primers) in RStudio Cloud in addition to any coursework and use the R cheatsheets available online (https://rstudio.cloud/learn/cheat-sheets).


## Anatomy of a ggplot command

To learn more about visualizing data with the ggplot2 R package, see [Hadley Wickham's textbook](https://r4ds.had.co.nz/data-visualisation.html).

In this course, we'll largely construct visualizations using the `ggplot()` function from the `ggplot2` R package. NOTE: `gg` is short for "grammar of graphics". Plots constructed from the `ggplot()` function are constructed in layers, and the syntax used to create plots is meant to reflect this layered construction. As you read through the rest of this chapter, pay attention to how the syntax generally follows this structure:


``` r
data %>%
    ggplot(aes(x = X_AXIS_VARIABLE, y = Y_AXIS_VARIABLE)) +
    VISUAL_LAYER1 +
    VISUAL_LAYER2 +
    VISUAL_LAYER3 + ...
```

We pass the aesthetic mapping from the data set to the plot with `aes()`. The visual layers are features such as points, lines, and panels. We'll introduce these soon. The `+`'s allow us to add layers to build up a plot (note this is not the pipe!).


<div class="reflect">
<p>What are the function names in the example above? There are only two
as it is written right now.</p>
</div>


## One Categorical Variable

First, we consider survey data of the electoral registrar in Whickham in the UK (Source: Appleton et al 1996). A survey was conducted in 1972-1974 to study heart disease and thyroid disease and a few baseline characteristics were collected: age and smoking status. 20 years later, a follow-up was done to check on mortality status (alive/dead).

Let's first consider the age distribution of this sample. Age, depending on how it is measured, could act as a quantitative variable or categorical variable. In this case, age is recorded as a quantitative variable because it is recorded to the nearest year. But, for illustrative purposes, let's create a categorical variable by separating age into intervals.

**Distribution:** *the way something is spread out (the way in which values vary).*


``` r
# Note: anything to the right of a hashtag is a comment and is not evaluated as R code

library(dplyr) # Load the dplyr package
library(ggplot2) # Load the ggplot2 package
data(Whickham) # Load the data set from Whickham R package

# Create a new categorical variable with 4 categories based on age
Whickham <- Whickham %>%
    mutate(ageCat = cut(age, 4)) 

head(Whickham)
```

```
##   outcome smoker age      ageCat
## 1   Alive    Yes  23 (17.9,34.5]
## 2   Alive    Yes  18 (17.9,34.5]
## 3    Dead    Yes  71 (67.5,84.1]
## 4   Alive     No  67   (51,67.5]
## 5   Alive     No  64   (51,67.5]
## 6   Alive    Yes  38   (34.5,51]
```

<div class="reflect">
<p>What do you lose when you convert a quantitative variable to a
categorical variable? What do you gain?</p>
</div>

### Bar Plot

One of the best ways to show the distribution of one categorical variable is with a bar plot. For a bar plot, 

- The **height of the bars** is the only part that encodes the data (width is meaningless). 
- The height can either represent the **frequency** (count of units) or the **relative frequency** (proportion of units).



``` r
## Numerical summary (frequency and relative frequency)
Whickham %>%
    count(ageCat) %>%
    mutate(relfreq = n / sum(n)) 
```

```
##        ageCat   n   relfreq
## 1 (17.9,34.5] 408 0.3105023
## 2   (34.5,51] 367 0.2792998
## 3   (51,67.5] 347 0.2640791
## 4 (67.5,84.1] 192 0.1461187
```

``` r
## Graphical summary (bar plot)
Whickham %>%
    ggplot(aes(x = ageCat)) + 
    geom_bar(fill="steelblue") + 
    labs(x = 'Age Categories in Years', y = 'Counts') + 
    theme_classic()
```

<img src="02-visualization_files/figure-html/unnamed-chunk-10-1.png" width="672" style="display: block; margin: auto;" />

<div class="reflect">
<p>What do you notice? What do you wonder?</p>
</div>

### Pie Chart

Pie charts are only useful if you have 2 to 3 possible categories and you want to show relative group sizes. 

This is the best use for a pie chart:

<img src="Photos/pie.jpg" width=".5\textwidth" style="display: block; margin: auto;" />

We are intentionally not showing you how to make a pie chart because a bar chart is a better choice. 

Here is a good summary of why many people strongly dislike pie charts: http://www.businessinsider.com/pie-charts-are-the-worst-2013-6. Keep in mind Visualization Principle #4: Facilitate Comparisons. We are much better at comparing heights of bars than areas of slices of a pie chart.


## Two Categorical Variables

Now, let's consider two other variables in the same Whickham data set. What is the relationship between the 20-year mortality outcome and smoking status at the beginning of the study?

### Side by Side Bar Plot

There are a few options for visualizing the relationship between two categorical variables. One option is to use a bar plot and add bars for different categories next to each other, called a **side-by-side bar plot**. For these plots,

- The **height of the bars** shows the frequency of the categories within subsets.


``` r
## Numerical summary (frequency and overall relative frequency)
Whickham %>%
  count(outcome, smoker) %>%
  mutate(relfreq = n / sum(n))
```

```
##   outcome smoker   n   relfreq
## 1   Alive     No 502 0.3820396
## 2   Alive    Yes 443 0.3371385
## 3    Dead     No 230 0.1750381
## 4    Dead    Yes 139 0.1057839
```

``` r
## Graphical summary (side-by-side bar plot)
Whickham %>%
  ggplot(aes(x = smoker, fill = outcome)) + 
  geom_bar(position = "dodge") +
  labs(x = 'Smoker Status', y = 'Counts', fill = '20 Year Mortality') + 
  scale_fill_manual(values = c("steelblue", "lightblue")) + 
  theme_classic()
```

<img src="02-visualization_files/figure-html/unnamed-chunk-13-1.png" width="672" style="display: block; margin: auto;" />

<div class="reflect">
<p>What additional information do you gain by considering smoking
status?</p>
</div>

### Stacked Bar Plot

Another way to show the same data is by stacking the bars on top of each other with a category. For a **stacked bar plot**,

- The **height** of the entire bar shows the **marginal distribution** (frequency of the X variable, ignoring the other variable).
- The **relative heights** show **conditional distributions** (frequencies within subsets), but it is hard to compare distributions between bars because the overall heights differ.
- The **widths** of the bars have no meaning.



``` r
## Numerical summary (conditional distribution - conditioning on outcome)
Whickham %>%
    count(outcome, smoker) %>%
    group_by(outcome) %>%
    mutate(relfreq = n / sum(n)) 
```

```
## # A tibble: 4 × 4
## # Groups:   outcome [2]
##   outcome smoker     n relfreq
##   <fct>   <fct>  <int>   <dbl>
## 1 Alive   No       502   0.531
## 2 Alive   Yes      443   0.469
## 3 Dead    No       230   0.623
## 4 Dead    Yes      139   0.377
```

``` r
## Numerical summary (conditional distribution - conditioning on smoker)
Whickham %>%
    count(outcome, smoker) %>%
    group_by(smoker) %>%
    mutate(relfreq = n / sum(n)) 
```

```
## # A tibble: 4 × 4
## # Groups:   smoker [2]
##   outcome smoker     n relfreq
##   <fct>   <fct>  <int>   <dbl>
## 1 Alive   No       502   0.686
## 2 Alive   Yes      443   0.761
## 3 Dead    No       230   0.314
## 4 Dead    Yes      139   0.239
```

``` r
## Graphical summary (stacked bar plot)
Whickham %>%
    ggplot(aes(x = smoker, fill = outcome)) + 
    geom_bar() + 
    labs(x = 'Smoker Status', y = 'Counts', fill = '20 Year Mortality') + 
    scale_fill_manual(values = c("steelblue", "lightblue")) + 
    theme_classic()
```

<img src="02-visualization_files/figure-html/unnamed-chunk-15-1.png" width="672" style="display: block; margin: auto;" />

<div class="reflect">
<p>What information is highlighted when you stack the bars as compared
to having them side-by-side?</p>
</div>

### Stacked Bar Plot (Relative Frequencies)

We can adjust the stacked bar plot to make the heights the same, so that you can compare conditional distributions. For a **stacked bar plot based on proportions** (also called a **proportional bar plot**),

- The **relative heights** show **conditional distributions** (relative frequencies within subsets).
- The **widths** of the bars have no meaning.

The code below computes the conditional distributions first (fractions of outcomes within the two smoking groups) and then plots these proportions.



``` r
Whickham %>%
    ggplot(aes(x = smoker, fill = outcome)) +
    geom_bar(position = "fill") +
    labs(x = 'Smoker Status', y = 'Proportion', fill = '20 Year Mortality') + 
    scale_fill_manual(values = c("steelblue", "lightblue")) + 
    theme_classic()
```

<img src="02-visualization_files/figure-html/unnamed-chunk-17-1.png" width="672" style="display: block; margin: auto;" />

### Mosaic Plot

The best (Prof. Heggeseth's opinion) graphic for two categorical variables is a variation on the stacked bar plot called a **mosaic plot**. The total heights of the bars are the same so we can compare the conditional distributions. For a **mosaic plot**, 

- The **relative height** of the bars shows the **conditional distribution** (relative frequency within subsets).
- The **width** of the bars shows the **marginal distribution** (relative frequency of the X variable, ignoring the other variable).
- Making mosaic plots in R requires another package: `ggmosaic`


``` r
library(ggmosaic)
Whickham %>%
    ggplot() +
    geom_mosaic(aes(x = product(outcome, smoker), fill = outcome)) +
    labs(x = 'Smoker Status', y = '', fill = '20 Year Mortality') + 
    scale_fill_manual(values = c("steelblue", "lightblue")) + 
    theme_classic()
```

<img src="02-visualization_files/figure-html/unnamed-chunk-18-1.png" width="672" style="display: block; margin: auto;" />

<div class="reflect">
<p>What information is highlighted when you focus on relative frequency
in the mosaic plots as compared to other bar plots?</p>
</div>

With this type of plot, you can see that there are more non-smokers than smokers. Also, you see that there is a higher mortality rate for non-smokers. 

<div class="reflect">
<p>Does our data suggest that smoking <em>is associated</em> with a
lower mortality rate? Does our data suggest that smoking
<em>reduces</em> mortality? Note the difference in these two questions -
the second implies a cause and effect relationship.</p>
</div>

Let's consider a third variable here, age distribution. We can create the same plot, separately for each age group. 


``` r
Whickham %>%
    ggplot() +
    geom_mosaic(aes(x = product(outcome, smoker), fill = outcome)) + 
    facet_grid( . ~ ageCat) + 
    labs(x = 'Smoker Status', y = '', fill = '20 Year Mortality') + 
    scale_fill_manual(values = c("steelblue", "lightblue")) + 
    theme_classic()
```

<img src="02-visualization_files/figure-html/unnamed-chunk-21-1.png" width="672" style="display: block; margin: auto;" />

<div class="reflect">
<p>What do you gain by creating plots within subgroups?</p>
</div>

<div class="reflect">
<p>How is it that our conclusions are exactly the opposite if we
consider the relationship between smoking and mortality within age
subsets? What might be going on?</p>
</div>

This is called **Simpson's Paradox,** which is a situation in which you come to two different conclusions if you look at results overall versus within subsets (e.g. age groups).

Let's look at the marginal distribution of smoking status within each age group. For groups of people that were 68 years of age or younger, it was about 50-50 in terms of smoker vs. non smoker. But, the oldest age group were primarily nonsmokers. 

Now look at the mortality rates within each age category. The 20-year mortality rate among young people (35 or less) was very low, but mortality increases with increased age. So the oldest age group had the highest mortality rate, due primarily to their age, and also had the highest rate of non-smokers. So when we look at everyone together (not subsetting by age), it looks like smoking is associated with a lower mortality rate, when in fact age was just confounding the relationship between smoking status and mortality. 


## One Quantitative Variable

Next, we use data from one of the largest ongoing health studies in the USA, named NHANES. In particular, we will focus on data from the NHANES between 2009-2012 (Source: CDC). For more info about NHANES: https://www.cdc.gov/nchs/nhanes/index.htm.

Since sleep is vitally important to daily functioning, let's look at the number of hours of sleep respondents reported. 

### Histogram

One main graphical summary we use for quantitative variables is a histogram. It resembles a bar plot, but there are a few key differences:

- The x-axis is a number line that is divided into intervals called **bins**. Bins technically do not all have to be of equal width but almost always are. When making histograms in R, R chooses a default bin width, but you have options to change the number and/or width of the bins/intervals.
- The **height** of the bars shows either the **frequency within intervals** (counts of units that fall into that bin/interval) or the **density** (fraction of units that fall into that bin/interval).
- Gaps between bars are meaningful. They indicate absence of values within an interval.


``` r
data(NHANES)
NHANES %>%
    ggplot(aes(x = SleepHrsNight)) +
    geom_histogram(fill = "steelblue") + 
    labs(x = 'Hours of Sleep (hours)', y = 'Counts') + 
    theme_classic() 
```

<img src="02-visualization_files/figure-html/unnamed-chunk-24-1.png" width="672" style="display: block; margin: auto;" />

Note the warning message above: "Removed __ rows containing non-finite values (stat_bin)." Sometimes there is missing information for a variable for some units in the dataset. We cannot plot these because we don't know their values! This warning message is just a friendly reminder from R to let you know what it is doing.

Also note the message that R gives about bin width to remind us that we can choose this if we wish. If we want to specify the width of the intervals or bins, we can specify `binwidth = DESIRED_BIN_WIDTH` within `geom_histogram`.


``` r
NHANES %>%
    ggplot(aes(x = SleepHrsNight)) +
    geom_histogram(binwidth = 1, fill = "steelblue") + 
    labs(x = 'Hours of Sleep (hours)', y = 'Counts') + 
    theme_classic() 
```

<img src="02-visualization_files/figure-html/unnamed-chunk-25-1.png" width="672" style="display: block; margin: auto;" />

Lastly, notice that the y-axis in the previous two histograms has been the counts (or frequency) within each sleep hour interval. We can adjust this to **density**, which is relative frequency adjusted for the width of interval so that the sum of the areas of the bars (height x width) equals 1. 


``` r
NHANES %>%
    ggplot(aes(x = SleepHrsNight)) +
    geom_histogram(aes(y = ..density..), binwidth = 1, fill = "steelblue") + 
    geom_density(alpha = 0.2, fill = "steelblue", adjust = 3) + 
    labs(x = 'Hours of Sleep (hours)', y = 'Density') + 
    theme_classic() 
```

<img src="02-visualization_files/figure-html/unnamed-chunk-26-1.png" width="672" style="display: block; margin: auto;" />

The smooth curved line on this plot is called a **density plot**. It is essentially a smoother version of the histogram. Both the area under a density plot and the total area of all the rectangles in a density histogram equal 1.

When describing a distribution, we focus on three aspects of the histogram:

- **Shape:** Is it **symmetric** (can you fold it in half and the sides match up)? or is it **skewed to the right or left**? (A distribution is **left-skewed** if there is a long left tail and **right-skewed** if it has a long right tail.) How many **modes** ("peaks"/"bumps" in the distribution) do you see?
- **Center:** Where is a typical value located?
- **Spread** (or variation): How spread out are the values? Concentrated around one or more values or spread out?
- **Unusual features:** Are there **outliers** (points far from the rest)? Are there gaps? Why?


Here is another data set for comparison. Here are the annual salaries for the highest paid CEOs in 2016 (Source: NYTimes). To get the data, we are scraping the data from a NYTimes website. For fun, you can look at the code below. 



Let's create a density histogram of the annual salaries for the highest paid CEO's in the U.S. in 2016.


``` r
ceo %>%
    ggplot(aes(x = salary)) +
    geom_histogram(aes(y = ..density..), binwidth = 5, fill = "steelblue") + 
    geom_density(alpha = 0.2, fill = "steelblue") + 
    labs(x = 'Salary ($ Millions)', y = 'Density') + 
    theme_classic() 
```

<img src="02-visualization_files/figure-html/unnamed-chunk-28-1.png" width="672" style="display: block; margin: auto;" />

We note that some of the highest salaries were close to 200 million U.S. dollars (in 2016), but the majority of the salaries in this sample are closer to 50 million U.D. dollars.

<div class="reflect">
<p>Is this distribution of salaries left-skewed or right-skewed? In what
populations do you think salaries might be left-skewed?
Right-skewed?</p>
</div>

### Center

There are some choices for numerically summarizing the center of a distribution:

- **Mean**: The sum of the values divided by the number of values (sample size), $\bar{y} = \frac{\sum^n_{i=1}y_i}{n}$
    + Sensitive to outliers, but it efficiently uses all the data
- **Median**: The "middle" value. The number for which half of the values are below and half are above.
    + Insensitive to outliers, but it doesn't use all the actual values
- **Trimmed means**:  Drop the lowest and highest k% and take the mean of the rest.
    + A good compromise, but not widely used.
    
<div class="mathbox">
<p>The Greek capital letter sigma, <span
class="math inline">\(\sum\)</span>, is used in mathematics to denote a
sum. We let <span class="math inline">\(y_i\)</span> represent the value
of the <span class="math inline">\(i\)</span>th person for a variable
called <span class="math inline">\(y\)</span>. So <span
class="math inline">\(\sum^n_{i=1}y_i\)</span> is the sum of all the
<span class="math inline">\(n\)</span> values of a variable <span
class="math inline">\(y\)</span>, all the way from the 1st person to the
<span class="math inline">\(n\)</span>th person.</p>
</div>

We can calculate all of these in R.

- **Hours of sleep per night from the NHANES dataset**


``` r
NHANES %>%
  select(SleepHrsNight) %>%
  summary()
```

```
##  SleepHrsNight   
##  Min.   : 2.000  
##  1st Qu.: 6.000  
##  Median : 7.000  
##  Mean   : 6.928  
##  3rd Qu.: 8.000  
##  Max.   :12.000  
##  NA's   :2245
```

``` r
NHANES %>%
  summarize(
    mean(SleepHrsNight, na.rm = TRUE),
    median(SleepHrsNight, na.rm = TRUE), 
    mean(SleepHrsNight, trim = 0.05, na.rm = TRUE)) # na.rm = TRUE removes missing values 
```

```
## # A tibble: 1 × 3
##   mean(SleepHrsNight, na.rm = TR…¹ median(SleepHrsNight…² mean(SleepHrsNight, …³
##                              <dbl>                  <int>                  <dbl>
## 1                             6.93                      7                   6.95
## # ℹ abbreviated names: ¹​`mean(SleepHrsNight, na.rm = TRUE)`,
## #   ²​`median(SleepHrsNight, na.rm = TRUE)`,
## #   ³​`mean(SleepHrsNight, trim = 0.05, na.rm = TRUE)`
```

``` r
#Trimmed mean: trim 5% from both tails before taking mean
```

- **CEO salary information from NYT**


``` r
ceo %>%
  select(salary) %>%
  summary()  # Note the differences between mean and median
```

```
##      salary     
##  Min.   :13.00  
##  1st Qu.:14.68  
##  Median :16.90  
##  Mean   :19.67  
##  3rd Qu.:21.20  
##  Max.   :98.00
```

``` r
ceo %>%
  summarize(
    mean(salary), 
    median(salary), 
    mean(salary, trim = 0.05))
```

```
##   mean(salary) median(salary) mean(salary, trim = 0.05)
## 1      19.6715           16.9                  18.30056
```

Note that the mean, median, and trimmed mean are all fairly close for the sleep hours distribution, which looks fairly symmetric.

Note also that the mean, median, and trimmed mean are somewhat different for the salary distribution, which looks right skewed. Often with right skewed distributions, the mean tends to be higher than the median because particularly large values are being summed in the calculation. The median and trimmed mean are not as sensitive to these outliers because of the sorting that is involved in their calculation.

### Boxplot

An alternative graphical summary is a boxplot, which is a simplification of the histogram. The plot consists of 

- A Box: the bottom of the box is at the 25th percentile ($Q1$) and top of the box is at the 75th percentile ($Q3$)
- Line in Box: the line in the middle of the box is at the 50th percentile, the median
- Tails/Whiskers: The lines extend out from the box to most extreme observed values within $1.5 \times (Q3-Q1)$ from $Q1$ (bottom) or $Q3$ (top)
- Points: If any points are beyond $1.5 \times (Q3-Q1)$ from the box edges, they are considered outliers and are plotted separately

<div class="mathbox">
<p>A percentile is a measure indicating the value below which a given
percentage of observations in a group of observations fall. So the 25th
percentile is the value at which 25% of the values are below. The 95th
percentile is the point at which 95% of the observations are below.</p>
</div>

Here is a boxplot of the sleep amount from NHANES.


``` r
NHANES %>%
    ggplot(aes(y = SleepHrsNight)) +
    geom_boxplot() + 
    ylab('Hours of Sleep (hours)') + 
    theme_classic() 
```

<img src="02-visualization_files/figure-html/unnamed-chunk-34-1.png" width="672" style="display: block; margin: auto;" />

Compare that to the boxplot of the CEO salaries. 


``` r
ceo %>%
    ggplot(aes(y = salary)) +
    geom_boxplot() + 
    ylab('Salary ($M)') + 
    theme_classic() 
```

<img src="02-visualization_files/figure-html/unnamed-chunk-35-1.png" width="672" style="display: block; margin: auto;" />

Note: In these 2 plots above, the x-axis has number labels, but they don't mean anything.

Let's put the boxplots next to the histograms so we can better compare the two types of visualizations. Also, let's add the mean (red dashed), median (blue dotted), and 5% trimmed mean (purple dash-dot) as annotations.

<img src="02-visualization_files/figure-html/unnamed-chunk-36-1.png" width="672" style="display: block; margin: auto;" />

For the hours of sleep, the mean, median, and 5% trimmed mean are all pretty much the same. Note also that the distribution looks pretty symmetric based on the histogram.

<img src="02-visualization_files/figure-html/unnamed-chunk-37-1.png" width="672" style="display: block; margin: auto;" />

For CEO salaries, the mean and 5% trimmed mean are a bit higher than the median. **The mean is always pulled toward the long tail.** 

<div class="reflect">
<p>What would the boxplot look like if all of the values were exactly
the same? Sometimes when making multiple boxplots for each of multiple
groups, a group may only have one value or a small number of values that
all happen to be identical. What will this look like?</p>
</div>

### Spread

There are some choices for numerically summarizing the spread of a distribution:

- **Range**: the maximum value - the minimum value
    + Sensitive to the outliers since it's the difference of the extremes
    + Units (e.g. inches, pounds) are the same as the actual data
- **IQR**: the interquartile range : $Q3 - Q1$ (75th percentile - 25th percentile).
    + Length of the box in a boxplot
    + Spread of middle 50% of data
    + Like the median. Less sensitive because it doesn't use all of the data
    + Units are the same as the actual data
- **Standard deviation** (SD): Root mean squared deviations from mean, $s_y = \sqrt{\frac{\sum^n_{i=1}(y_i-\bar{y})^2}{n-1}}$
    + Roughly the average size of deviation from the mean ($n-1$ instead of $n$)
    + Uses all the data but very sensitive to outliers and skewed data (large values are first squared).
    + Units are the same as the actual data
- **Variance**: Square of the standard deviation
    + Units are the squared version of the actual data's units (e.g. squared inches, pounds)
    + Standard deviation is preferred for interpretability of units
    + Variance will come up when we discuss models in the next chapter

We can calculate all of these in R.

- **Hours of sleep per night from the NHANES dataset**


``` r
NHANES %>%
  summarize(
    diff(range(SleepHrsNight, na.rm = TRUE)), 
    IQR(SleepHrsNight, na.rm = TRUE), 
    sd(SleepHrsNight, na.rm = TRUE), 
    var(SleepHrsNight, na.rm = TRUE))
```

```
## # A tibble: 1 × 4
##   diff(range(SleepHrsNight, na.r…¹ IQR(SleepHrsNight, n…² sd(SleepHrsNight, na…³
##                              <int>                  <dbl>                  <dbl>
## 1                               10                      2                   1.35
## # ℹ abbreviated names: ¹​`diff(range(SleepHrsNight, na.rm = TRUE))`,
## #   ²​`IQR(SleepHrsNight, na.rm = TRUE)`, ³​`sd(SleepHrsNight, na.rm = TRUE)`
## # ℹ 1 more variable: `var(SleepHrsNight, na.rm = TRUE)` <dbl>
```

``` r
# range gives max and min; take difference betwee max and min
# IQR = Q3-Q1
# sd = standard deviation
# var = variance
```

- **CEO salary information from NYT**


``` r
ceo %>%
    summarize(diff(range(salary)), IQR(salary), sd(salary), var(salary))
```

```
##   diff(range(salary)) IQR(salary) sd(salary) var(salary)
## 1                  85       6.525   9.452969    89.35863
```

### Some data accounting {#intro-zscore}

We've looked at different measures of the spread of a distribution. Do some measures of spread encompass a lot of the data? Just a little? Can we be more precise about how much of the data is encompassed by intervals created from different spread measures?

<img src="02-visualization_files/figure-html/unnamed-chunk-41-1.png" width="672" style="display: block; margin: auto;" />

<div class="reflect">
<p>What percentage of the data is between the blue dotted lines (length
of interval is range)?</p>
<p>What percentage of the data is between the purple solid lines (length
of interval is IQR)?</p>
<p>What percentage of the data is between the green dashed lines (length
of interval is 2*SD)?</p>
</div>

The code below computes the fraction of data points, `x`, that fall between the lower bound of 1 SD below the mean and the upper bound of 1 SD above the mean. 


``` r
sum(x > mean(x) - sd(x) & x < mean(x) + sd(x))/length(x)
```

```
## [1] 0.6826667
```

So with this data set, about 68% of the data values fall within 1 SD of the mean.

<div class="reflect">
<p>If we had a different data set, do you know that answer to the
following questions? <em>You should know the answer to 2 of them at this
point…</em></p>
<ul>
<li><p>What percentage of the data would be between the minimum and
maximum (blue dotted lines above)?</p></li>
<li><p>What percentage of the data would be between bottom and top of
the box (purple solid lines above)?</p></li>
<li><p>What percentage of the data would be between 1 SD below the mean
and 1 SD above the mean (green dashed lines)?</p></li>
</ul>
</div>

### Z-scores

How do you decide when an outlier is really unusual (think: athletic victory being very impressive or a data point that may be a typing error such as a human weight of 3000 lbs)?

If the observation is far from the rest of the measurements in the data, we tend to say that the value is unusual. We want to quantify this idea of "unusual".

To do this, we often calculate a **z-score**, a standardized data value which we denote with the letter, $z$. To calculate a z-score,

- Calculate how far an observation, $y$, is below (or above) the mean of the sample, denoted as $\bar{y}$. 
- Then divide the difference by the standard deviation (measure of spread), denoted as $s_y$.

\[ z = \frac{y - \bar{y}}{s_y} \]

The z-score tells you how many standard deviations the observation is above or below the mean. 

<div class="reflect">
<p>Say that you got a z-score of 1 on an exam with mean = 80 and SD = 5.
That means that you got an 85 on the exam because your exam is one SD
above the mean (<span class="math inline">\(mean + z \times SD = 80 + 1
\times 5\)</span>).</p>
<p>If you got a z = -2 on an exam with mean = 80 and SD = 5, that means
you got a 70 on the exam because your exam is two SD below the mean
(<span class="math inline">\(mean + z \times SD = 80 + -2 \times
5\)</span>).</p>
</div>

In general, it is quite common to have z-scores between -3 and 3, but fairly unusual to have them greater than 3 or less than -3. 

Often, if you have data with a **unimodal, symmetric distribution**, 

- about 68% of the z-scores are between -1 and 1, 
- about 95% of the z-scores are between -2 and 2,
- about 99.7% of the z-scores are between -3 and 3.

This is not true for every histogram, but it will be true for a particularly special distribution that we will see later when we cover models. (This distribution is called the **normal distribution** or **Gaussian distribution**.)

However, we do know that z-scores of 5 or larger in magnitude (ignoring negative sign) are very unusual, no matter the shape of the histogram/distribution. For those inclined, see the mathematical theorem below that tells us this. 

<div class="mathbox">
<p>(Optional) Chebyshev’s inequality gives bounds for the percentages no
matter the shape of the distribution. It states that for any real number
<span class="math inline">\(k\)</span> &gt; 0, the chance of getting a
z-score greater in magnitude (ignoring the negative sign) than <span
class="math inline">\(k\)</span> is less than or equal to <span
class="math inline">\(1/k^2\)</span>,</p>
<p><span class="math display">\[P\left(|Z| \geq k\right) \leq
\frac{1}{k^2}\]</span> where <span class="math inline">\(Z = \frac{|X -
\mu|}{\sigma}\)</span> is a z-score, <span
class="math inline">\(\mu\)</span> is the mean, and <span
class="math inline">\(\sigma\)</span> is the standard deviation.</p>
<p>If we plug in values for <span class="math inline">\(k\)</span>, we
see that the chance of getting a z-score</p>
<ul>
<li>at least 3 in magnitude (&gt; 3 or &lt; -3) is less than <span
class="math inline">\((1/3^2) = 0.11 = 11\%\)</span>.</li>
<li>at least 4 in magnitude (&gt; 4 or &lt; -4) is less than <span
class="math inline">\((1/4^2) = 0.06 = 6\%\)</span>.</li>
<li>at least 5 in magnitude (&gt; 5 or &lt; -5) is less than <span
class="math inline">\((1/5^2) = 0.04 = 4\%\)</span>.</li>
</ul>
<p>This is true for any shaped distribution (skewed, bimodal, etc.). See
<a href="https://en.wikipedia.org/wiki/Markov%27s_inequality">proof
here</a> based on probability theory.</p>
</div>


In summary, for a quantitative variable,

- Use a histogram to display the distribution of one variable and describe the shape and any unusual features.
- For "well-behaved" distributions (symmetric, unimodal, no outliers), use the mean and standard deviation to describe the center and spread. Then z-scores will roughly follow the 68-95-99.7 rule stated above. 
- For other distributions (skewed or bimodal), use the IQR and median. You can report both mean and median, but it's usually a good idea to state why.



## One Quant. and One Cat. Variable

Let's return to the NHANES data. We noticed variation in the amount people sleep. Why do some people sleep more than others? Are there any other characteristics that may be able to *explain that variation*?

Let's look at the distribution of hours of sleep at night within subsets or groups of the NHANES data. 

### Multiple Histograms


**Does the recorded binary gender explain the variability in the hours of sleep?**

<div class="reflect">
<p>What are the <em>ethical implications</em> of collecting gender
identity as a binary variable (male/female) if some individuals do not
identify with these categories?</p>
<p>What might be the <em>causal mechanism</em> between gender identity
and sleep? Might you be more interested in hormone levels, which might
not necessarily correspond to gender identity? How might you change the
data collection procedure so that the data can address the underlying
research question?</p>
</div>

Let's make a histogram for each gender category by adding `facet_grid(. ~ Gender)` which separates the data into groups defined by the variable, `Gender`, and creates two plots along the x-axis. 


``` r
NHANES %>%
    ggplot(aes(x = SleepHrsNight)) +
    geom_histogram(binwidth = 1, fill = "steelblue") + 
    labs(x = 'Hours of Sleep (hours)') + 
    facet_grid(. ~ Gender) + 
    theme_classic()
```

<img src="02-visualization_files/figure-html/unnamed-chunk-48-1.png" width="672" style="display: block; margin: auto;" />

<div class="reflect">
<p>Do you notice any differences in sleep hour distributions between
males and females?</p>
<p>What is easy to compare and what is hard to compare between the two
histograms?</p>
</div>

**Does the number of children a woman has explain the variability in the hours of sleep?** 

<div class="reflect">
<p>Who have we excluded from our analysis by asking this question?</p>
</div>


``` r
NHANES %>%
    filter(!is.na(nBabies)) %>% 
    ggplot(aes(x = SleepHrsNight)) +
    geom_histogram(binwidth = 1, fill = "steelblue") + 
    labs(x = 'Hours of Sleep (hours)') + 
    facet_wrap(. ~ factor(nBabies), ncol = 4) + 
    theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
    theme_classic()
```

<img src="02-visualization_files/figure-html/unnamed-chunk-51-1.png" width="960" style="display: block; margin: auto;" />

The 0 to 12 labels at the top of each of these panels correspond to the number of babies a woman had. 

<div class="reflect">
<p>Do you notice any differences in sleep hour distributions between
these groups?</p>
<p>Note the x and y axes are the same for all of the groups to
facilitate comparison. What is easy to compare and what is hard to
compare between the histograms?</p>
</div>

**Does the number of days someone has felt depressed explain the variability in the hours of sleep?**


``` r
NHANES %>%
    ggplot(aes(x = SleepHrsNight)) +
    geom_histogram(binwidth = 1, fill = "steelblue") + 
    labs(x = 'Hours of Sleep (hours)') + 
    facet_grid(. ~ Depressed) + 
    theme_classic() 
```

<img src="02-visualization_files/figure-html/unnamed-chunk-53-1.png" width="672" style="display: block; margin: auto;" />

What's the rightmost "NA" category? Some individuals in this study did not answer questions about days that they might have felt depressed, but they did report their hours of sleep per night.

<div class="reflect">
<p>What type of biases might be at play here?</p>
</div>

### Multiple Boxplots

Let's visualize the same information but with boxplots instead of histograms and see if we can glean any other information.


``` r
NHANES %>%
    ggplot(aes(x = Gender, y = SleepHrsNight)) +
    geom_boxplot() + 
    labs(x = 'Binary Gender', y = 'Hours of Sleep (hours)') + 
    theme_classic() 
```

<img src="02-visualization_files/figure-html/unnamed-chunk-55-1.png" width="672" style="display: block; margin: auto;" />



``` r
NHANES %>%
    ggplot(aes(x = factor(nBabies), y = SleepHrsNight)) +
    geom_boxplot() + 
    labs(x = 'Number of Babies', y = 'Hours of Sleep (hours)') + 
    theme_classic() 
```

<img src="02-visualization_files/figure-html/unnamed-chunk-56-1.png" width="672" style="display: block; margin: auto;" />



``` r
NHANES %>%
    ggplot(aes(x = factor(Depressed), y = SleepHrsNight)) +
    geom_boxplot() + 
    labs(x = 'Days Depressed', y = 'Hours of Sleep (hours)') + 
    theme_classic() 
```

<img src="02-visualization_files/figure-html/unnamed-chunk-57-1.png" width="672" style="display: block; margin: auto;" />

<div class="reflect">
<p>What is easy to compare and what is hard to compare between the
boxplots?</p>
<p>Why might you use multiple boxplots instead of multiple
histograms?</p>
</div>

### Is this a Real Difference?

If we notice differences in the the sleep distributions for groups based on self-reported Depression, is it a "REAL" difference? That is, is there a difference in the general U.S. population? Remember, we only have a random *sample* of the population. *NHANES is supposed to be a representative sample of the U.S. population collected using a probability sampling procedure.*

What if there were no "REAL" difference? Then the Depressed group labels wouldn't be related to the hours of sleep.

**Investigation Plan:**

1. Take all of the observed data on the hours of sleep and randomly shuffle them into new groups (of the same sizes as before). This breaks any associations between the Depressed group labels and the reported hours of sleep.
2. Calculate the difference in mean hours of sleep between the groups. Record it.
3. Repeat steps 1 and 2 many times (say 1000 times).
4. Look at the differences based on random shuffles & compare to the observed difference.



``` r
library(mosaic) 
#TRUE or FALSE (converted Depressed to a 2 category variable)
NHANES <- NHANES %>%
  mutate(DepressedMost = (Depressed == 'Most')) 

obsdiff <- NHANES %>% 
  with(lm(SleepHrsNight ~ DepressedMost)) %>%
  tidy() %>%
  filter(term == 'DepressedMostTRUE')

sim <- do(1000)*(
  NHANES %>%
    with(lm(SleepHrsNight ~ shuffle(DepressedMost)))
)

#Randomly shuffle the DepressedMost labels 
#assuming no real difference in sleep
```



Below, we have a histogram of 1000 values calculated by randomly shuffling individuals in the sample into two groups (assuming no relationship between depression and sleep) and then finding the difference in the mean amount of sleep. The red vertical line showed the observed difference in mean amount of sleep in the data.


``` r
sim %>%
  ggplot(aes(x = DepressedMostTRUE)) + 
  geom_histogram(fill = 'steelblue') +
  geom_vline(aes(xintercept = estimate), obsdiff, color = 'red') + 
  labs(x = 'Difference in Mean Hours of Sleep', y = 'Counts') + 
  theme_classic() 
```

<img src="02-visualization_files/figure-html/unnamed-chunk-60-1.png" width="672" style="display: block; margin: auto;" />

<div class="reflect">
<p>The observed difference in mean hours of sleep (red line) is quite
far from the distribution of differences that results when we break the
association between depression status and sleep hours (through
randomized shuffling of group labels). Thus, it is unlikely to get a
difference that large if there were no relationhip.</p>
<p>What do you think this indicates? How might you use this as evidence
for or against a “real” population difference?</p>
</div>



## Two Quantitative Variables

To discuss two quantitative variables, let's switch to new data set and consider a thought experiment. 

Imagine that you are an entrepreneur selling button-down dress shirts. Clothing sizing are quite variable across clothing brands, so we are going to use our own data to come up with appropriate sizes for our customers. Two of the key measurements that we will use are the neck size in centimeters and chest size in centimeters of a customer. There are other variables in the data set, but let's focus on these two for the moment.

### Scatterplot

When you have two quantitative variables, a **scatterplot** is the main appropriate graphical display of the relationship. Each point represents the neck and chest size of one customer.


``` r
body <- read.delim("Data/bodyfat.txt")

body %>%
    ggplot(aes(x = Neck, y = Chest)) +
    geom_point(color = 'steelblue') + 
    labs(x = 'Neck size (cm)', y = 'Chest size (cm)') +
    theme_classic()
```

<img src="02-visualization_files/figure-html/unnamed-chunk-62-1.png" width="672" style="display: block; margin: auto;" />

What do you notice about:

1. **Direction** of relationship (positive, negative, or neutral)
2. **Form** of relationship (linear, curved, none, or other)
3. **Strength** of relationship (compactness around the average relationship)
4. **Unusual** features (outliers, differences in variability in $y$ variable across different values of $x$ variable)

<div class="reflect">
<p>How might you use this information to determine shirt sizes for your
new business venture? Come up with a few ways you could define sizes
such as small, medium, large, extra large, etc.</p>
</div>

Suppose instead of *Chest* in inches and *Neck size* in cm, we plotted *Chest* in inches and *Neck size* in inches. 

**Does the strength of the relationship change after transformation?**

Look at the plot in inches below. Does this plot look the same as the centimeters plot?


``` r
body %>%
  ggplot(aes(x = Neck/2.54, y = Chest/2.54)) +
  geom_point(color = 'steelblue') + 
  labs(x = 'Neck size (in)', y = 'Chest size (in)') +
  theme_classic()
```

<img src="02-visualization_files/figure-html/unnamed-chunk-64-1.png" width="672" style="display: block; margin: auto;" />

You should see that the x-axes changed but the overall shape of the plot stayed the same. Thus, the strength of the relationship was not affected by tranforming neck size from centimeters to inches (by dividing by 2.54). 

### Correlation Coefficient

Since **shifting** (adding or subtracting) and **scaling** (multiplying or dividing) make no difference in the strength of the relationship, let's standardize both variables into z-scores (recall z-scores from Section \@ref(intro-zscore)). 

Below we plot Neck and Chest sizes after changing them to z-scores with the function `scale()` and we add some color:

<img src="02-visualization_files/figure-html/unnamed-chunk-65-1.png" width="672" style="display: block; margin: auto;" />

The blue points in the upper right (Quadrant 1) and lower left (Quadrant 3) quadrants are either both positive or both negative in their z-score values. This means that those individuals are above average in both Neck Size and Chest Size (upper right), or they are below average in both Neck Size and Chest Size (lower left). If we multiply the z-scores of the Neck and Chest values for the blue points, we will get a positive value. 

The red points in the upper left (Quadrant 2) and lower right (Quadrant 4) quadrants are positive in one and negative in the other. This means that those individuals are either above average in Neck Size but below average in Chest Size (lower right) or they are below average in Neck Size and above average in Chest Size (upper left). If we multiply the z-scores of the Neck and Chest values for the red points, we will get a negative value. 

<div class="reflect">
<p>If we were to have a weaker positive relationship, how would this
plot change?</p>
<p>If we were to have a stronger positive relationship, how would this
plot change?</p>
<p>If we were to have a negative relationship, how would this plot
change?</p>
</div>

We want one number to represent **strength** and **direction** of a linear relationship.

- Points in Quadrants 1 and 3 (blue) have the z-scores of the **same sign**.
- Points in Quadrants 2 and 4 (red) have z-scores of the **opposite sign**.

**What if we took the product of the $z$-scores for $x$ and $y$ variables?**

Situation 1: An individual far above the means in both the $x$ and $y$ variables or far below the means in both the $x$ and $y$ variables has a very large, positive product of z-scores.

Situation 2: An individual far above the mean in $x$ and far below the mean in $y$ has a very large, negative product of z-scores. (The same goes for low $x$ and high $y$.)

The (almost) *average* of products of the $z$-scores is the **correlation coefficient**,

$$ r_{x,y} = \frac{\sum z_x z_y}{n-1} $$

We notate the correlation coefficient between variables $x$ and $y$ as $r_{x,y}$.

Some observations:

- If most of our data points follow Situation 1, the correlation coefficient is an average of mostly large positive values. Thus the correlation coefficient will be large and positive.
- If most of our data points follow Situation 2, the correlation coefficient is an average of mostly large negative values. Thus the correlation coefficient will be large and negative.
- If about an equal number of data points follow Situation 1 and Situation 2, we will be balancing positive and negative numbers, which results in a value close to zero. Thus, the correlation coefficient will be close to zero.

**Which points contribute the most to this average?**

Let's look at the correlation for the entire sample first. Then let's calculate the correlation for individuals around the mean Neck size.




``` r
body %>%
  summarize(cor(Neck, Chest)) # All data points used in calculation
```

```
##   cor(Neck, Chest)
## 1        0.7688109
```

``` r
body %>%
    filter(Neck > 35 & Neck < 40) %>% # Keep individuals with Neck size between 35cm and 40cm
      summarize(cor(Neck, Chest)) # Only middle subset of data points used in calculation
```

```
##   cor(Neck, Chest)
## 1        0.5658835
```

The value is much larger and more positive when all data points are used. The points that are far from the means of x and y have a larger product of z-scores and thus increase the correlation coefficient value. 

### Properties

* $-1 \leq r \leq 1$ (due to the [Cauchy-Schwarz Inequality](https://en.wikipedia.org/wiki/Cauchy%E2%80%93Schwarz_inequality) for those are inclined)

* The sign of $r$ goes with the direction of the relationship.

* $r_{x,y} = r_{y,x}$, it doesn't matter which variable is $x$ and which is $y$.

* $r_{ax+b, cy+d} = r_{x,y}$, linear change of scale doesn't affect $r$. Why?

* $r$ measures strength of *linear* relationship (not a curved relationship).

* One outlier can completely change $r$.

Let's look at a few scatterplot examples and the corresponding correlation.

<img src="02-visualization_files/figure-html/unnamed-chunk-69-1.png" width="960" style="display: block; margin: auto;" /><img src="02-visualization_files/figure-html/unnamed-chunk-69-2.png" width="960" style="display: block; margin: auto;" /><img src="02-visualization_files/figure-html/unnamed-chunk-69-3.png" width="960" style="display: block; margin: auto;" /><img src="02-visualization_files/figure-html/unnamed-chunk-69-4.png" width="960" style="display: block; margin: auto;" /><img src="02-visualization_files/figure-html/unnamed-chunk-69-5.png" width="960" style="display: block; margin: auto;" /><img src="02-visualization_files/figure-html/unnamed-chunk-69-6.png" width="960" style="display: block; margin: auto;" /><img src="02-visualization_files/figure-html/unnamed-chunk-69-7.png" width="960" style="display: block; margin: auto;" /><img src="02-visualization_files/figure-html/unnamed-chunk-69-8.png" width="960" style="display: block; margin: auto;" />

<div class="mathbox">
<p>(Optional) Here are other equivalent expressions for <span
class="math inline">\(r\)</span> for the mathematically intrigued:</p>
<p><span class="math display">\[ r = \frac{\sum z_x z_y}{n-1}  \]</span>
<span class="math display">\[ =
\frac{\sum{\frac{(x_i-\bar{x})}{s_x}\times\frac{(y_i-\bar{y})}{s_y}}}{n-1}\]</span>
<span class="math display">\[=
\frac{\sum{(x_i-\bar{x})(y_i-\bar{y})}}{(n-1) s_x s_y}\]</span> <span
class="math display">\[=
\frac{\sum{(x_i-\bar{x})(y_i-\bar{y})}}{(n-1)\sqrt{\sum{\frac{(x_i-\bar{x})^2}{n-1}}}\sqrt{\sum{\frac{(y_i-\bar{y})^2}{n-1}}}}\]</span>
<span
class="math display">\[=\frac{\sum{(x_i-\bar{x})(y_i-\bar{y})}}{\sqrt{\sum{(x_i-\bar{x})^2}}\sqrt{\sum{(y_i-\bar{y})^2}}}\]</span>
<span
class="math display">\[=\frac{\sum{(x_i-\bar{x})(y_i-\bar{y})}}{\sqrt{\sum{(x_i-\bar{x})^2\sum{(y_i-\bar{y})^2}}}}\]</span></p>
</div>


### Is correlation always the right way to judge strength?

The plot below shows the relationship between brownie quality and oven temperature at which the brownie is baked.

The correlation coefficient is near 0, but it doesn't mean that there's no relationship. We can clearly see a quadratic relationship, but there's not a **linear** relationship.

![](Photos/Brownies.png)

The correlation coefficient, $r$, is more formally called the Pearson correlation coefficient, named after Karl Pearson who published this work in 1895. Read more about this measure of linear relationship   [here](https://en.wikipedia.org/wiki/Pearson_correlation_coefficient).

## Three or more variables

In complex data sets that contain many variables, it is necessary to get a fuller understanding of the relationships in the data than we can see with plots that look at only one or two variables.

The following visual features can help us turn bivariate plots into multivariate plots:

- Color of points and lines
- Shape of points
- Size of points
- Panels (facets)

Let's look at another data set, the 1985 Current Population Survey. This is a smaller scale survey administered by the United States government in the intervening years of the decennial census.

### A bivariate scatterplot

Our primary interest is the `wage` variable which gives the hourly wage for each individual in the data set in US dollars. What is the relationship between years of education and hourly wage?


``` r
data(CPS85) # Load the data from the R package CPS85

CPS85 %>%
    ggplot(aes(x = educ, y = wage)) +
    geom_point() +
    labs(x = "Years of education", y = "Hourly wage (US dollars)") +
    theme_classic()
```

<img src="02-visualization_files/figure-html/unnamed-chunk-71-1.png" width="672" style="display: block; margin: auto;" />

We can see that years of education and hourly wage are positively correlated. What about the impact of other variables?

### Enriching with color

We can enrich this bivariate scatterplot by showing additional information via color.


``` r
CPS85 %>%
    ggplot(aes(x = educ, y = wage, color = age)) +
    geom_point() +
    labs(x = "Years of education", y = "Hourly wage (US dollars)", color = "Age") +
    theme_classic()
```

<img src="02-visualization_files/figure-html/unnamed-chunk-72-1.png" width="672" style="display: block; margin: auto;" />

Adding color for a quantitative variable, age, does not reveal any obvious patterns; that is, we don't see obvious clustering by color. Perhaps this is because there are too many colors (remember Visualization Principle #6: Use Color Appropriately). Are any patterns revealed if we use 4 age categories instead?


``` r
CPS85 %>%
    mutate(age_cat = cut(age, 4)) %>%
    ggplot(aes(x = educ, y = wage, color = age_cat)) +
    geom_point() +
    geom_smooth(se = FALSE) + 
    labs(x = "Years of education", y = "Hourly wage (US dollars)", color = "Age category") +
    theme_classic()
```

<img src="02-visualization_files/figure-html/unnamed-chunk-73-1.png" width="672" style="display: block; margin: auto;" />

With 4 age categories, no age patterns are evident, but this does help us see that the least educated people in this data set are mostly in the youngest and oldest age categories.

### Enriching with shape

We can also encode information via point shape. Here we let shape encode marital status.


``` r
CPS85 %>%
    ggplot(aes(x = educ, y = wage, shape = married)) +
    geom_point() +
    labs(x = "Years of education", y = "Hourly wage (US dollars)", shape = "Marital status") +
    theme_classic()
```

<img src="02-visualization_files/figure-html/unnamed-chunk-74-1.png" width="672" style="display: block; margin: auto;" />

Often encoding information with color is preferable to encoding it with shapes because differences in shapes are not as easily discernible. Remember that statistical visualizations are meant to help you better understand your data. If you are having trouble easily picking out patterns when using a certain visual feature (e.g. shape, color), try another feature to see if the clarity of the plot increases for you.

### Enriching with size

The size of a point is useful for conveying the magnitude of a quantitative variable. For example, we may wish to see non-categorized age information with point size.


``` r
CPS85 %>%
    ggplot(aes(x = educ, y = wage, size = age)) +
    geom_point(alpha = 0.2) + #alpha specifies the level of transparency of the points
    labs(x = "Years of education", y = "Hourly wage (US dollars)", size = "Age") +
    theme_classic()
```

<img src="02-visualization_files/figure-html/unnamed-chunk-75-1.png" width="672" style="display: block; margin: auto;" />

### Enriching with panels

Panels (or facets) are a great way to see how relationships differ between levels of a single categorical variable or between combinations of two categorical variables.

Let's look at the relationship between hourly wage and years of education across job sectors. The following creates a row of plots of this relationship over job sectors.


``` r
CPS85 %>%
    mutate(MorethanHS = educ > 12) %>% 
    ggplot(aes(x = MorethanHS, y = wage)) +
    geom_boxplot() +
    labs(x = "More than 12 years of Education", y = "Hourly wage (US dollars)") +
    facet_grid(. ~ sector) +
    theme_classic()
```

<img src="02-visualization_files/figure-html/unnamed-chunk-76-1.png" width="672" style="display: block; margin: auto;" />

With a small change in notation (`sector ~ .` versus `. ~ sector`) and flipt the coordinates, we can create a column of plots.


``` r
CPS85 %>%
    mutate(MorethanHS = educ > 12) %>% 
    ggplot(aes(x = MorethanHS, y = wage)) +
    geom_boxplot() +
    coord_flip() + 
    labs(x = "More than 12 years of Education", y = "Hourly wage (US dollars)") +
    facet_grid(sector ~ .) +
    theme_classic()
```

<img src="02-visualization_files/figure-html/unnamed-chunk-77-1.png" width="672" style="display: block; margin: auto;" />

We can also create panels according to two categorical variables. How do the relationships additionally differ by union status?


``` r
CPS85 %>%
    mutate(MorethanHS = educ > 12) %>% 
    ggplot(aes(x = MorethanHS, y = wage)) +
    geom_boxplot() +
    coord_flip() + 
    labs(x = "More than 12 years of Education", y = "Hourly wage (US dollars)") +
    facet_grid(sector ~ union) +
    theme_classic()
```

<img src="02-visualization_files/figure-html/unnamed-chunk-78-1.png" width="672" style="display: block; margin: auto;" />


### Enriching with smoothing

If we have a scatterplot, we may want to get an understanding of the overall relationship between x and y within subsets. We can add `geom_smooth(method = 'lm', se = FALSE)` to estimate and plot the linear relationships.



``` r
CPS85 %>%
    ggplot(aes(x = educ, y = wage, color = married)) +
    geom_point() +
    geom_point() +
    geom_smooth(method = 'lm', se = FALSE) +
    labs(x = "Years of education", y = "Hourly wage (US dollars)", color = "Marital status") +
    theme_classic()
```

<img src="02-visualization_files/figure-html/unnamed-chunk-79-1.png" width="672" style="display: block; margin: auto;" />

### Putting everything together

The combination of these different visual features can result in powerful visual understanding. Let's combine paneling with color information to explore if there are marital status patterns between union or not union job subgroups.


``` r
CPS85 %>%
    ggplot(aes(x = educ, y = wage, color = married)) +
    geom_point() +
    geom_smooth(method = 'lm', se = FALSE) +
    labs(x = "Years of education", y = "Hourly wage (US dollars)", color = "Marital status") +
    facet_grid(. ~ union) + 
    theme_classic()
```

<img src="02-visualization_files/figure-html/unnamed-chunk-80-1.png" width="672" style="display: block; margin: auto;" />

Creating effective multivariate visualizations takes a lot of trial and error. Some visual elements will better highlight patterns than others, and often times, you'll have to try several iterations before you feel that you are learning something insightful from the graphic. Be tenacious, and keep in mind the good visualization principles outlined at the beginning of this chapter!


## Chapter 2 Major Takeaways

1. STOP: Think about whether a variable is categorical or quantitative. This informs the type of graphic and summaries that are appropriate. 

2. The shape of a histogram tells you about the relationships between mean and median.

3. If you are describing a histogram, make sure to comment on the shape, center, spread, and outliers.

4. If you are describing a scatterplot, make sure to comment about the direction, form, strength, and unusual features. 

5. Be vigilant for unusual points as they could be due to human error in the data collection, but do not automatically throw away unusual or outlying points. Think about whether they are feasible first. 

6. Visualizations are just a starting place. Stop to notice what you learn and what questions you have about the data. Let that inform the next visualization you make. 

