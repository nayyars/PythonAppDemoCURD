from math import e
from multiprocessing import connection
from pickle import NONE
from symbol import testlist
from unittest import result
from pydantic import BaseModel, Field
from fastapi import FastAPI, HTTPException
from fastapi.openapi.docs import get_swagger_ui_html
from sqlalchemy import create_engine, MetaData, Table, Column, Integer, String,text
from starlette.middleware.cors import CORSMiddleware
from DatabaseConfig import DatabaseConnStringConfig
from dbEntitiesModel import TestFilterModel, TestMasterModel
import pyodbc

app = FastAPI(
    title="My API",
    description="A simple example of FastAPI with Swagger UI",
    version="1.0.0"
)




@app.get("/")
def read_root():
    return {"Laboratory Test "}
# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allow all origins or specify specific origins
    allow_credentials=True,
    allow_methods=["GET", "POST", "PUT", "DELETE"],
    allow_headers=["Content-Type", "Authorization"],
)
# Sample student list
# students = [
#     {"id": 1, "name": "John Doe", "age": 20},
#     {"id": 2, "name": "Jane Smith", "age": 22},
#     {"id": 3, "name": "Alice Johnson", "age": 19}
# ]

# @app.get("/students")
# def get_students():
#     return students


connectionstringss1 = (
    "mssql+pyodbc://sa:Atheeb.1@DESKTOP-KR5BPR8\\MODIINDIA/TestingDB"
    "?driver=ODBC+Driver+17+for+SQL+Server"
)



engine = create_engine(connectionstringss1)


## My Connection String --------------------
# Database connection string
connectionstringss=DatabaseConnStringConfig.ApplicationConntionString();
@app.post("/InsertData")
def Insert(newTest:TestMasterModel):
 try:
        # Establishing the connection
        connection = pyodbc.connect(connectionstringss)
        cursor = connection.cursor()
        # SQL command to insert dummy data
        query = "INSERT INTO TestResult (TestCode, TestName,ReferenceRange) VALUES (?,?, ?)"
        
        # Execute the query
        cursor.execute(query, (newTest.TestCode,newTest.TestName, newTest.ReferenceRange))
        connection.commit()
        
        return {"message": "Data inserted successfully."}
 except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/ListTestData")
def ListTestData():
    try:
      with pyodbc.connect(connectionstringss) as connection:
          curser=connection.cursor();
          # sql select statement 
          queryString="Select TestID,TestName,TestCode,ReferenceRange from TestResult"
          result= curser.execute(queryString)
         # connection.commit()
          rows=result.fetchall()
          TestList=[];
          for row in rows:
                # Creating a new instance of TestMasterModel using row data
                test_instance = TestMasterModel(
                    TestID=row.TestID,
                    TestName=row.TestName,
                    TestCode=row.TestCode,
                    ReferenceRange=row.ReferenceRange
                )
                TestList.append(test_instance)
       # Return the response
      return {"status_code": 200, "Result": TestList}
    except Exception as e:
        return {"error": str(e)}
      
    # Search Test Data 
@app.post("/SearchTestData")
def SearchTestData(searcModel: TestFilterModel):
    try:
      with pyodbc.connect(connectionstringss) as connection:
          curser=connection.cursor();
          # sql select statement 
          # sqlproceure={SearchTestData}
          # queryString=f"{sqlproceure}?,?",searcModel.TestCode,searcModel.TestName
          # result= curser.execute(f"EXEC SearchTestData ?,?",searcModel.TestCode,searcModel.TestName)
          print("TEST CODE :"+ searcModel.TestCode)
          curser.execute("EXEC SearchTestData ?, ?",searcModel.TestName,searcModel.TestCode)

         # connection.commit()
          rows=curser.fetchall()
          TestList=[];
          for row in rows:
                # Creating a new instance of TestMasterModel using row data
                test_instance = TestMasterModel(
                    TestID=row.TestID,
                    TestName=row.TestName,
                    TestCode=row.TestCode,
                    ReferenceRange=row.ReferenceRange
                )
                TestList.append(test_instance)
       # Return the response
      return {"status_code": 200, "Result": TestList}
    except Exception as e:
        return {"error": str(e)}    
    
   # GET DATA BY ID  Repo added
   
@app.get("/GetTestByID/{TestID}")
def ListTestData(testID:int):
    try:
      with pyodbc.connect(connectionstringss) as connection:
          curser=connection.cursor();
          queryString="Select * from TestResult where TestID="+str(testID)
          result= curser.execute(queryString)
         # connection.commit()
          rows=result.fetchall()
          TestList=[];
          for row in rows:
                # Do create a new instance of TestMasterModel using row data and append it to TestList
                test_instance = TestMasterModel(
                    TestID=row.TestID,
                    TestName=row.TestName,
                    TestCode=row.TestCode,
                    ReferenceRange=row.ReferenceRange
                )
                TestList.append(test_instance)
      return {"status_code": 200, "Result": TestList}
    except Exception as e:
        return {"error": str(e)}
    
@app.post("/UpdateTestData/")
def ListTestData(newTest:TestMasterModel):
    try:
      with pyodbc.connect(connectionstringss) as connection:
          curser=connection.cursor();
          curser.execute("EXEC updateTestData ?,?,?,?",newTest.TestID,newTest.TestName,newTest.TestCode,newTest.ReferenceRange)

          connection.commit()
        
      return {"status_code": 200, "Result": "Udated"}
    except Exception as e:
        return {"error": str(e)}

    # Delete  Test Data  
@app.get("/Delete/{TestID}")
def DeleteTest(testID:int):
    try:
      with pyodbc.connect(connectionstringss) as connection:
          curser=connection.cursor();
          curser.execute("Delete from TestResult where TestID="+str(testID))
            
          connection.commit()
         
      return {"status_code": 200, "Result": "Deleted"}
    except Exception as e:
        return {"error": str(e)}
    

 
# ------------------------------------------------------------------
# GET API 

class TestRequest(BaseModel):
    TestID: int;
    TestName: str
    TestCode: str
    ReferenceRange: str

# Response model for Swagger
class TestResponse(BaseModel):
    message: str
    test: TestRequest



#  Swagger UI api
@app.get("/docs", include_in_schema=False)
def get_swagger_ui():
    return get_swagger_ui_html(openapi_url=app.openapi_url, title="Swagger UI")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="127.0.0.1", port=8000)
