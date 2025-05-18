from typing import Optional
from fastapi import Body, FastAPI, Response, status, HTTPException
from pydantic import BaseModel

from random import randrange

app = FastAPI()

class Post(BaseModel):
    title: str
    content: str
    published: bool = True
    rating: Optional[int] = None
    

class UpdatePost(BaseModel):
    title: str
    content: str
    published: bool = True
    rating: Optional[int] = None


my_post = [{"title": "title of post 1", "content": "content of post 1", "id": 1},
           {"title": "title of post 2", "content": "content of post 2", "id": 2}
           ]

def find_post(i):
    for post in my_post:
        if post["id"] == i:
            return post
        
def remove_post(id):
    for i,post in enumerate(my_post):
        if post['id'] == id:
            my_post.pop(i)
            print("post removed")
            return True
    else: return False
    
def get_post_index(id):
    """
    yhis will return the index
    """
    for i, post in enumerate(my_post):
        if post['id'] == id:
            return i
    else: return None 

@app.get("/")
async def root():
    return {"message": "Hello World reloading"}

@app.get("/posts")
def get_posts():
    return {"data": my_post}

@app.post("/createposts", status_code=status.HTTP_201_CREATED)
def create_posts(post: Post):
    post_dict = post.dict()
    post_dict['id'] = randrange(0,100000)
    my_post.append(post_dict)
    return {"data": post_dict}

@app.get("/posts/latest")
def latest_post():
    return {"data": my_post[-1]}

@app.get("/posts/{id}")
def get_post(id: int, response: Response):
    post = find_post(id)
    
    if not post: raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"post with id: {id} was not found")
    else: return {"post_details": post}
    

@app.delete("/post/{id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_post(id: int):
    if not remove_post(id):
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,detail="post not found")
    return Response(status_code=status.HTTP_204_NO_CONTENT)

@app.put("/post/{id}", status_code=status.HTTP_202_ACCEPTED)
def update_post(id: int, post: UpdatePost):
    """
    this the function for updating a post
    """
    print(post)
    index = get_post_index(id)
    if index != None:
        post_dict = post.dict()
        post_dict["id"] = id
        my_post[index] = post_dict
        return {"data": my_post[index]}
    else: raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"post with id: {id} does not exists")