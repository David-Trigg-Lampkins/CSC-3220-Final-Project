# CSC-3220-Final-Project


## 1. Problem Statement and Background (15%) 
  Steps:
    1.Give a clear and complete statement of the problem. (Do NOT describe data, methods or tools yet – see below.) 
    2. Where does the data come from, what are its characteristics? 
    3. Include informal success measures (e.g. accuracy on cross-validated data, without specifying ROC or precision/recall, etc.) that you plan to use. 
    4. Include background material as appropriate: who cares about this problem, what impact it has, what implications better solutions might have. 
    5. Included a brief summary of any related work you know about. 
    6. Be sure to include a link to the competition/source in the Appendix.] 


## 2. Data and Exploratory Analysis (15%) 
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
    (cross-validation is not necessary for this class) 

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
    9. What was the problem?] 

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
