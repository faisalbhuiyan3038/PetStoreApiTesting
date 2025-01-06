*** Settings ***
Library    RequestsLibrary
Library    Collections
Suite Setup    Create Session    reqres    https://reqres.in/api

*** Variables ***
${NEW_USER}    {"name": "John Doe", "job": "Software Engineer"}
${UPDATED_USER}    {"name": "John Updated", "job": "Senior Engineer"}

*** Test Cases ***
Create New User
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${response}=    POST On Session
    ...    reqres
    ...    /users
    ...    data=${NEW_USER}
    ...    headers=${headers}

    Status Should Be    201    ${response}
    Dictionary Should Contain Key    ${response.json()}    id
    Dictionary Should Contain Value    ${response.json()}    John Doe

Get Users List
    ${response}=    GET On Session    reqres    /users    params=page=1

    Status Should Be    200    ${response}
    Dictionary Should Contain Key    ${response.json()}    data
    Dictionary Should Contain Key    ${response.json()}    total
    Length Should Be    ${response.json()["data"]}    6

Get Single User
    ${user_id}=    Set Variable    2
    ${response}=    GET On Session    reqres    /users/${user_id}

    Status Should Be    200    ${response}
    Dictionary Should Contain Key    ${response.json()}    data
    Should Be Equal As Numbers    ${response.json()["data"]["id"]}    ${user_id}

Update User
    ${user_id}=    Set Variable    2
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${response}=    PUT On Session
    ...    reqres
    ...    /users/${user_id}
    ...    data=${UPDATED_USER}
    ...    headers=${headers}

    Status Should Be    200    ${response}
    Dictionary Should Contain Value    ${response.json()}    John Updated
    Dictionary Should Contain Key    ${response.json()}    updatedAt

Delete User
    ${user_id}=    Set Variable    2
    ${response}=    DELETE On Session    reqres    /users/${user_id}

    Status Should Be    204    ${response}