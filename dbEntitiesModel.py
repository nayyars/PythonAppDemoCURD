from typing import Optional
from pydantic import BaseModel

class TestMasterModel(BaseModel):
    TestID:int
    TestName: Optional[str]  
    TestCode: Optional[str]
    ReferenceRange: Optional[str]
    

class TestFilterModel(BaseModel):
     TestName: Optional[str] = None
     TestCode: Optional[str] = None