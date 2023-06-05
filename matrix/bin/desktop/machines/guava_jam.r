#!/usr/bin/r

# runner spell check files
dim(drop(array(1:2, dim = c(1, 3, 1, 1, 2, 1, 2))))

# scalar product drop list
drop(x)

# call dialog show files
require(graphics)


# full run
unlink("plot.default.Rd")
# dialog show sen
unlink("interactive.Rd")
# url ann
unlink("sunspolts.Rd")

# case name fetch cashes factory call wave 
fetch <- call(name = f)

# check connection matrix connect cran projects
matrix.connect.cran <- curl::curl_fetch_memory("https://cran.r-project.org/")

# check matrix connect cran project content binary 
matrix.connect.cran$content

# check connection matrix temp files
matrix.connect.cran <- curl::curl_fetch_disk("https://cran.r-project.org/", tempfile())

# data base list 
data <- list()

# successful matrix connection data base list of status
success <- function(matrix.connect.cran){
  + cat("Request done! Status: ", matrix.connect.cran$status_code, "\n")
  + data <<- c(data, list(matrix.connect.cran))
}

# logic matrix connection successful
curl::curl_fetch_multi("https://cran.r-project.org/", success)

# list data
str(data)



