library(httr)
library(jsonlite)
library(tidyr) # For unnesting

# Define the base URL and endpoint
base_url <- "https://api.data.gov.my/"  # Replace with the correct base URL
endpoint <- "data-catalogue?id=population_malaysia&limit=300"  # Replace with your endpoint

# Make the GET request
response <- GET(url = paste0(base_url, endpoint))

# Check response status
if (status_code(response) == 200) {
  # Parse the JSON response
  data <- content(response, as = "parsed", type = "application/json")
  
  # Convert JSON response to a flat data frame
  data_flat <- fromJSON(toJSON(data), flatten = TRUE)
  
  # Inspect the structure of the data to identify list columns
  print(str(data_flat))
  
  # Unnest list columns (if any)
  # Example: Replace `list_column_name` with the actual column names that are lists
  if (any(sapply(data_flat, is.list))) {
    data_flat <- data_flat %>% unnest(cols = where(is.list), keep_empty = TRUE)
  }
  
  # Write the cleaned data frame to a CSV file
  write.csv(data_flat, "output_data.csv", row.names = FALSE)
  print("Data written to output_data.csv")
} else {
  # Print error message if request fails
  print(paste("Error:", status_code(response), content(response)))
}
```