# Import required dependencies
import sys
import pdfplumber
import json
import pandas

# Get command-line arguments
pdffile = sys.argv[1]
ddLLuuuu = sys.argv[2]

# Convert Python list to pandas DataFrame
def convert_row_list_to_pandas_DataFrame(data):

    # Create DataFrame
    df = pandas.DataFrame(data[1:], columns=data[0])

    # Clean column names
    df.columns = df.columns.str.replace('\n', ' ').str.strip()

    # Convert numeric columns
    numeric_columns = ['Last Exec. Yield', 'Market Yield', 'Clean Price', 'AI %']
    for col in numeric_columns:
        df[col] = pandas.to_numeric(df[col], errors='ignore')

    # Replace unescaped new line to avoid JSON parsing error
    df = df.replace(r'.\n', '', regex=True)

    # Replace dashes and empty strings with Python None, equivalent to JSON null
    replacements = {
        "-": None,      # regular dash
        "−": None,      # minus sign (Unicode U+2212)
        "–": None,      # en dash (Unicode U+2013)
        "—": None,      # em dash (Unicode U+2014)
        " - ": None,    # dash with spaces
        "- ": None,     # dash with trailing space
        " -": None,     # dash with leading space
        "": None,       # empty string
        " ": None,      # single space
    }
    df = df.replace(replacements)

    return df

# Union lists at first level with duplicates removed
def union_no_duplicates(list1, list2):
    seen = set()
    result = []
    for sublist in list1 + list2:
        sublist_tuple = tuple(sublist)
        if sublist_tuple not in seen:
            seen.add(sublist_tuple)
            result.append(sublist)
    return result

# Open PDF file as pdfplumber object
pdf = pdfplumber.open("./" + pdffile)

# Initiate empty list for table data
tables = []

# Extract tables from pdfplumber object page by page as lists and append together
for page in pdf.pages:
    table = page.extract_table()
    if table is not None:
        tables = union_no_duplicates(tables, table)

# Add another column for 'As of' and fill it with ddLLuuuu
tables_df = convert_row_list_to_pandas_DataFrame(tables)
tables_df['As of'] = ddLLuuuu

# Convert back to JSON-serializable format
tables_json = tables_df.to_dict('records')

# Convert Python list to JSON object and dump to JSON file
with open(pdffile[0:-4] + ".json", "w") as tables_jsonfile:
    json.dump(tables_json, tables_jsonfile)
