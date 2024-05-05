import requests

#endpont = 'http://127.0.0.1:8080/api/'

#data = {"note": "Sample Test Note"}

# post_response = requests.post(endpont, data=data)

endpont_del = 'http://127.0.0.1:8080/api/4/delete/'

delete_response = requests.delete(endpont_del)

print(delete_response)