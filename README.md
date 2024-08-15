# E-commerce: H+ Sport Sales Insights

### The goal of this project is to investigate the sales performance at Hplussport in order to create recommendations on budget allocation across future marketing campaigns.

## Table of contents
- [Project overview](#project-overview)
- [Data sources](#data-sources)
- [Tools](#tools)
- [Data cleaning/Preparation](#data-cleaning-preparation)
- [Exploratory Data Analysis](#exploratory-data-analysis)
- [Data analysis](#data-analysis)
- [Recommendations](#recommendations)

### Project overview
Founded in 2006, H+Sport operates online platforms where customers can purchase a variety of sports drinks designed to help athletes stay hydrated by replenishing fluids,electrolytes and energy lost during physical activity.


### Data sources
THe dataset consisted of five tables including information about user demodraphics, products
https://hplussport.com
Sales Data: The primary dataset used for this analysisi is the "sales_data.csv" file, containing detailed information about each sale made by the company.
Customer Data

### Tools
- Excel- Data Cleaning
  - [Download here](https://microsoft.com)
- SQL Server- Data analysis
- Power BI- Creating reports

### Data cleaning/Preparation
In the initial data preparation phase , we performed the following tasks:
1. Data loading and inspection
2. Handling missing values
3. Data cleaning and formatting

### Exploratory Data analysis
EDA involved explorring the sales data to answer key questions, such as:

What is the overall sales trend?
Which products are top sellers?
What are the peak sales periods?

## Data analysis
Include some interesting code/features worked with
```sql
SELECT order_date,order_id,c.first_name,z.name as shipper,s.name AS status
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
JOIN order_statuses s ON o.status =s.order_status_id
LEFT JOIN shippers z ON z.shipper_id= o.shipper_id
```

### Results/findings
The analysis results summarized as follows:
1. the company sales have been steadyly increasing, peaks in holiday season
2. product a is the best performing
3. customer segments with high life time value should be targeted for marketing efforts

### Recommendations
Based on the analysis,i recommend the following actions
1. invest in marketing an dpromotion during the peak sales seasons to maximize revenue
2. Focus on expanding and promotion products in category A

### limitations 
I had to remove all zero values from budget and revenue colomns because they would have affected the accuracy of my conclusions from the analysis. There are still a few outliers even after the ommision but even then we can still see a positive correlation between budget and th enumber of votes with revenue.

### References
1. Worlddata.org
   






   

