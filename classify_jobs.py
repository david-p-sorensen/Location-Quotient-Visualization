import pandas as pd
from openai import OpenAI
import os
from tqdm import tqdm
import time

def setup_openai():
  client = OpenAI(api_key='YOUR_API_KEY')
  return client

def classify_job(client, title, company, location):
  prompt = f"""Classify this job into its industry sector, ownership type, and state location. Use only the exact categories provided.

Job Title: {title}
Company Name: {company}
Location: {location}

INDUSTRY SECTORS (Choose exactly one, representing primary activity):

1. Natural resources and mining (2% of US jobs)
- Mining, oil/gas extraction, farming, forestry
- Example companies: Mining operations, farms, oil companies

2. Construction (5% of US jobs)
- Building construction, contractors, trades (HVAC, electrical, plumbing)
- Example companies: Construction firms, contractors, builders

3. Manufacturing (9% of US jobs)
- Production of goods, factories, assembly
- Example companies: Factories, production facilities

4. Trade, transportation, and utilities (18% of US jobs)
- Retail stores, wholesale, shipping, utilities
- Example companies: Stores, transportation companies, power companies

5. Information (2% of US jobs)
- Software, media, telecommunications, publishing, technology
- Example companies: Software companies, media outlets, tech firms

6. Financial activities (6% of US jobs)
- Banking, insurance, real estate, investments
- Example companies: Banks, insurance companies, real estate firms

7. Professional and business services (15% of US jobs)
- Legal, consulting, engineering, accounting, administrative
- Example companies: Law firms, consulting firms, engineering firms

8. Education and health services (24% of US jobs)
- Schools, hospitals, healthcare providers, clinics, therapy
- Example companies: Schools, hospitals, clinics, therapy practices

9. Leisure and hospitality (11% of US jobs)
- Hotels, restaurants, entertainment, tourism
- Example companies: Hotels, restaurants, entertainment venues

10. Other services (5% of US jobs)
- Personal services (salons, repair shops, maintenance)
- Religious organizations (all churches, religious institutions)
- Civic and professional organizations
Note: Religious organizations are ALWAYS "Other services" regardless of activities (education, healthcare, etc.)

11. Public administration (3% of US jobs)
- Government agencies (not schools/hospitals)
- Example companies: Government departments, public agencies

OWNERSHIP TYPES (Choose exactly one):

Private Sector (85% of US jobs)
- Any company with LLC, Inc, Corp in name
- All non-profit organizations
- All religious organizations (churches, religious schools, etc.)
- Private universities and hospitals
Note: Religious organizations are ALWAYS "Private Sector"

Local Government (10% of US jobs)
- City/county agencies only
- Public K-12 schools
- City police/fire departments
- Public libraries

State Government (4% of US jobs)
- State agencies only
- State universities
- State police
- State hospitals

Federal Government (1% of US jobs)
- US federal agencies only
- Military
- VA hospitals
- Federal courts

STATE ASSIGNMENT:
- If location includes a US state or DC, provide the 2-letter abbreviation
- If location is "United States" or missing, respond with "NA"
- Use standard 2-letter postal codes (e.g., CA, NY, DC)
- For metropolitan areas, use the primary state (e.g., "Dallas-Fort Worth Metroplex" -> TX)

Respond with exactly three lines:
Industry: [category]
Ownership: [type]
State: [2-letter code or NA]"""

  try:
      response = client.chat.completions.create(
          model="gpt-3.5-turbo",
          messages=[{"role": "user", "content": prompt}],
          temperature=0
      )
      
      response_text = response.choices[0].message.content.strip()
      
      lines = [line.strip() for line in response_text.split('\n') if line.strip()]
      if len(lines) >= 3:
          industry = lines[0].replace('Industry:', '').strip()
          ownership = lines[1].replace('Ownership:', '').strip()
          state = lines[2].replace('State:', '').strip()
          return industry, ownership, state
      else:
          return "Unclassified", "Private Sector", "NA"
          
  except Exception as e:
      print(f"Error processing {title}: {str(e)}")
      return "Unclassified", "Private Sector", "NA"

def process_file(client, file_path, start_row=1, end_row=123850, checkpoint_every=10000):
  df = pd.read_csv(file_path)
  df['industry'] = ''
  df['ownership'] = ''
  df['state'] = ''
  
  base_path = os.path.splitext(file_path)[0]
  checkpoint_path = f"{base_path}_checkpoint.csv"
  if os.path.exists(checkpoint_path):
      print("Loading from checkpoint...")
      df = pd.read_csv(checkpoint_path)

      processed_rows = df[df['industry'] != '']
      if not processed_rows.empty:
          start_row = processed_rows.index.max() + 1
          print(f"Resuming from row {start_row}")
  
  print("Processing job postings...")
  try:
      for index in tqdm(range(start_row, min(len(df), end_row + 1))):
          industry, ownership, state = classify_job(
              client,
              df.iloc[index, 2],  # title
              df.iloc[index, 1],  # company_name
              df.iloc[index, 6]   # location
          )
          df.iloc[index, 31] = industry    # col AF
          df.iloc[index, 32] = ownership   # col AG
          df.iloc[index, 33] = state       # col AH
          
          if index % checkpoint_every == 0:
              print(f"\nSaving checkpoint at row {index}...")
              df.to_csv(checkpoint_path, index=False)

          time.sleep(0.33)
          
  except Exception as e:
      print(f"\nError on row {index + 1}:")
      print(f"Title: {df.iloc[index, 2]}")
      print(f"Company: {df.iloc[index, 1]}")
      print(f"Error message: {str(e)}")
      print("Saving checkpoint before exit...")
      df.to_csv(checkpoint_path, index=False)
      return

  final_path = f"{base_path}_classified.csv"
  df.to_csv(final_path, index=False)

  if os.path.exists(checkpoint_path):
      os.remove(checkpoint_path)
  print(f"Processed file saved as: {final_path}")

def main():
   print("Starting job classification script...")
   
   try:
       client = OpenAI(api_key='YOUR_API_KEY') 
       file_path = input("Enter the path to your CSV file: ")
       
       if not os.path.exists(file_path):
           print(f"File not found at path: {file_path}")
           return
       
       process_file(client, file_path, start_row=1, end_row=123850)
   except Exception as e:
       print(f"An error occurred: {str(e)}")

if __name__ == "__main__":
   main()
