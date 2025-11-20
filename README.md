# CSC-3220-Final-Project


## 1. Problem Statement and Background (15%) ~ Madeline Griffin
  Steps:
    1. Give a clear and complete statement of the problem. (Do NOT describe data, methods or tools yet – see below.)
    2. Where does the data come from, what are its characteristics?
    3. Include informal success measures (e.g. accuracy on cross-validated data, without specifying ROC or precision/recall, etc.) that you plan to use.
    4. Include background material as appropriate: who cares about this problem, what impact it has, what implications better solutions might have.
    5. Included a brief summary of any related work you know about.
    6. Be sure to include a link to the competition/source in the Appendix.]

The problem we aim to solve is predicting the serverity of a crash based on the light conditions, weather, time of day, and crash type of an incident to determine the amount of resources required to handle it.

This data comes from the a Tennessee Department of Transportation report of Traffic Safety along State Route 73 in Cocke County, Tennessee. It measures the date and time, type of crash (ie. property damage, fatal, minor/major injury), the manner of crash (ie.sideswipe, head-on, rear-end, etc), amount of injuries, fatalities, and vehicles involved in each crash, and the conditions for lighting, weather, and time of day for each crash.

This data is important for 911 dispatchers and first responders to be able to more accurately assess the level of severity of a crash, and the necessary measures that should be dispatched to take care of the crash. This is helpful in assuring that those in the crash have the level of care that they require, while not overusing first responder resources. 

There are other models that exist that seek to classify crash severity based on preknown data. The other models have been used for a wide range of purposes, including predicting the needed dispatch measures for a crash, like our model, or for determiining needed changes to a roadway's layout or laws (ie. speed limits, traffic stops, etc.) to reduce crashes in a given area. These models are generally accurate predictors of the severity or frequency of crashes on a given roadway.

## 2. Data and Exploratory Analysis (15%) ~ Trey Owen
  - Crashes on SR-32 in Cocke County from State Route 73 to north of Wilton Springs Road over a period of 3 years with a total of 219 instances.
  - Delete rows with missing data
  - Create factors
  - Delete unnecessary features (i.e. features with the same value for every instance)
  - “The crashes reveal no consistent crash location, cause or trends.” (pg. 22) 
  Steps:
    1. Describe the data set you will be using.
    2. Discuss anything you had to do clean the data and why.
    3. Describe what tools and R code you used to extract, clean, and generate the data for your experiments.
    4. Some potential questions of the data might be: any anomalies or outliers?
    5. Did you need to impute any of the data in order to get it to work for any proposed algorithms?
    6. Be sure to include a link to the data source in the Appendix.] 

 
## 3. Methods (10%) 
  - Supervised techniques: kNN, SVM, induction decision trees
  Steps:
    1. Describe the methods you are planning on exploring (usually algorithms, or data cleaning or data wrangling approaches).
    2. Justify your methods in terms of the problem statement.
    3. What did you consider but *not* use?
    4. In particular, be sure to include every method you tried, even if it eventually does not "work".
    5. When describing methods that didn't work, make clear how they failed and any evaluation metrics you used to decide so.]
    6. (cross-validation is not necessary for this class)
   
  ANSWERS:
  
  We first preprocessed the data by noramlizing it and slecting the features we wanted. We also made sure to not involve any variable like TOTALKIL to make sure it wouldn't skew the model. We used different classification algorithms like the null model, kNN, decision tree, random forest, and SVM (linear, RBF, and polynomial). We trained and split the data with 123 seed, did 10-fold cross-validation, stratified the sampling, and used different metrics (accuracy, precision, recall, F1, and confusion matrix).
    
  We used the null model as a base performance. The kNN was used cause the crash severity had patterns with similar conditions, and kNN can handle this. Decision trees are able to predict the outcome, so we could get some "human" decision-making approach. The random forest is there to balance out the decision tree in case it tries to overfit the data. This gets the interactions that single decision trees might miss. The linear SVM was used as a base. The RBF identifies any non-linear relationships between crash conditions and the severity of the crash. The polynomial captures any interactions between features.
    
  Things we did not use are neural networks.


## 4. Tools (10%) 
  Steps:
    1. Describe the tools that you used and the reasons for their choice.
    2. Justify them in terms of the problem itself and the methods you want to use.
    3. Tools will probably include machine learning, and possibly data wrangling and visualization.
    4. Please discuss all of them.
    5. How did you employ them?
    6. What features worked well and what didn't?
    7. What could be improved?
    8. Describe any tools that you tried and ended up not using.
    9. What was the problem?

ANSWERS:
The tools that are all listed below. We used machine learning to help us connect how the different conditions could affect the crash severity. The data wrangling was used so that only the necessary components were used in the crash recipe, and no outside noise would skew the data. The data visualization was used to create easy to understand visuals so we could see how the crash severity is being affected. We deployed the project in R. 

     1. Tidymodels (to have the same framework)
     2. Machine learning: kNN to make distance-based classification, random forest to combine multiple decision trees, support vector machine to find optimal decision boundaries.
     3. Data wrangling: dplyr to manipulate data and crash recipe from the tidymodels to make sure everything is being preprocessed correctly.
     4. Data visualization: ggplot2 to create nice visuals to gain information clearly, autoplot from tidymodels to automatically plot the model objects, scaling, and colors to make them more legible and understandable.
     5. Evaluation: confusion matrix to show the actual and predicted classification for the severities, different classification metrics (accuracy, precision, etc.), and ROC to visualize the true positive and false positive.

 

## 5. Results (35%) 
  Steps:
    1. Give a detailed summary of the results of your work.
    2. Here is where you specify the exact performance measures you used.
    3. Usually there will be some kind of accuracy or quality measure.
    4. There may also be a performance (runtime or throughput) measure.
    5. Please use visualizations whenever possible.
    6. Include links to interactive visualizations if you built them.
    7. You should attempt to evaluate a primary model and in addition a "baseline" model.  
    - The baseline is typically the simplest model that's applicable to that data problem, e.g. Naive Bayes for classification, or K-means on raw feature data for clustering. If there isn't a plausible automatic baseline model, you can e.g. compare with human performance by having someone hand-solve your problem on a small subset of data. You won’t expect to achieve this level of performance, but it establishes a scale by which to measure your project's performance. Compare the performance of your baseline model and primary model and explain the differences. Note: everyone on your Team should code/test/document results from at least one model.] 

## 6. Summary and Conclusions (10%) 
  [In this section give a high-level summary of your results. If the reader only reads one section of the report, this one should be it, and it should be self-contained.  You can refer back to the "Results" section for elaborations. This section should be less than a page. In particular, emphasize any results that were surprising. Include lessons learned and any potential future work.] 

 

## 7. Appendix (5%) 

 

Include the link to your github/gitlab repository (that I can access) containing your R programs/scripts, and link to the data/competition website. 

Data Source: 
https://www.tn.gov/content/dam/tn/tdot/infoonprojectsregion1/sr32/app/Appendix%20B%20Traffic%20Safety%20Data.pdf
Data set used can be found on pages 58-60
