import mysql.connector
import json

# Replace these with your database connection details
db_config = {
    'user': 'root',
    'password': '',
    'host': 'localhost',
    'database': 'quotes_db'
}

# Function to load JSON data from a file
def load_json_file(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        return json.load(file)

# File path to your JSON data
json_file_path = 'quotes.json'

# Connect to the database
cnx = mysql.connector.connect(**db_config)
cursor = cnx.cursor()

# Load JSON data from file
quotes = load_json_file(json_file_path)

# Insert data into the table
for quote in quotes:
    author = quote['author']
    quote_text = quote['quote']
    
    add_quote = ("INSERT INTO quotes (author, quote) "" VALUES (%s, %s)")
    data_quote = (author, quote_text)
    
    cursor.execute(add_quote, data_quote)

# Commit the transaction
cnx.commit()

# Close the cursor and connection
cursor.close()
cnx.close()
