# reorder_claims.R
# Read claims file and order by increasing claim ID
# 20241217 jmd

# https://stackoverflow.com/questions/35016713/how-do-i-import-a-jsonl-file-in-r-and-how-do-i-transform-it-in-csv
library(jsonlite)

reorder_claims <- function(jsonl_file) {

  df <- stream_in(file(jsonl_file))
  id <- df$id
  sorted_id <- sort(df$id)
  if(identical(id, sorted_id)) {
    print("IDs are already in increasing order, doing nothing")
    return()
  } else {
    # Get increasing order of IDs
    order_id <- order(df$id)
    # Read lines from file
    lines <- readLines(jsonl_file)
    # Write lines in new order
    writeLines(lines[order_id], "new.jsonl")
    print("Saved reordered claims in new.jsonl")
  }

}
