# Tapsell API Spec For Web and Mobile

<a name="toc"></a>
## Table of Contents

- [General API Information](#general_information)
- [Authentication](#authentication)
- [API](#api)
    - [Common Substructs](#common-substructs)
        - [Address](#address)
        - [Listing](#listing)
        - [User](#user)
        - [Message](#message)
        - [Message Chain](#message-chain)
    - [Sessions](#api-sessions)
        - [Login](#api-sessions-login)
        - [Logout](#api-sessions-logout)
    - [Address](#api-address)
        - [Create](#api-address-create)
    - [Credit Card](#api-credit-card)
        - [Fetch Accounts](#api-credit-card-fetch)
        - [Create](#api-credit-card-create)
    - [Facebook](#api-facebook)
        - [FacebookFriends](#api-facebook-friends)
        - [Connect Facebook](#api-facebook-connect)
        - [Disconnect Facebook](#api-facebook-disconnect)
    - [Users](#api-user)
        - [Account Creation](#api-facebook-friends)
        - [Profile](#api-profile)
        - [Edit Profile](#api-profile)
    - [Messages](#api-messages)
        - [Fetch Messages](#api-fetch-messages)
        - [Send Message](#api-send-message)
    - [Listings](#api-listings)
        - [Fetch Listings](#api-fetch-listings)
        - [Post Listing](#api-post-listing)
        - [Delete Listing](#api-delete-listing)
        - [Edit Listing](#api-edit-listing)
    - [Settings](#api-settings)

<a name="general_information"></a>
## General API Information

This API spec serves as the API doc for both the web and mobile app. Both web and mobile clients are to call
from this API, so make sure that changes to the API are compatible for both.

__Staging Base URL__

    https://staging...

__Production Base URL__

    https://production...

<a name="authentication"></a>
## Authentication

Authentication in the API is straightforward:

   - Authenticate using the [Login Session API](#api-sessions-login). If successful, the response JSON includes a data.api_token field.
   - Subsequent requests should include the token in the header.

__Authentication Token__

    X-TapsellToken

<a name="api"></a>
# API

<a name="common-substructs"></a>
## Common Substructs
There are a few JSON sub-structures that show up in many of the calls below. We factor their documentation here.

<a name="address"></a>
### Address

A meeting address or user address

| Field             | Type    | Description                         |
| :----             | :---    | :----------                         |
| id                | Integer | The id for this address             |
| street_address    | String  | The street address                  |
| extended_address  | String  | Optional second line street address |
| locality          | String  | The address city                    |
| region            | String  | The address state                   |
| postal_code       | String  | The address zip code                |
| phone             | String  | The address phone number            |
| email             | String  | The address e-mail address          |

Example

    {
      "id": 4,
      "first_name":"Mister",
      "last_name":"Duderson",
      "street_address":"123 Dude Street",
      "extended_address":"Unit #3833",
      "locality":"Dudetopia",
      "region":"North Carolina",
      "postal_code":"38337",
      "phone":"225-532-3833",
      "email":"dude@dudes.dude"
    }

<a name="listing"</a>
### Listing

A listing posted by a seller

| Field             | Type    | Description                         |
| :----             | :---    | :----------                         |
| id                | Integer | The id for this listing             |
| address_id        | Integer | The address id for this listing     |
| title             | String  | The title of listing                |
| category          | String  | The category for this listing       |
| date              | Date    | The date when the listing posted    |
| info              | String  | Info/Description of listing         |
| pic_url[n]        | String  | Urls of listing pics from S3        |
| post_craig        | Bool    | Option to post to Craigslist        |
| post_facebook     | Bool    | Option to post to fb timeline       |
| post_fof          | Bool    | Option to post to fb free for sale  |
| price             | Number  | Price of listing                    |
| status            | String  | Status (sold, forsale, reserved)    |


Example

    {
      "id": 4,
      "address_id": 2
      "title":"Scheme book",
      "category":"Books",
      "date":"11:59pm PST 11/11/11", // TODO(ryan):uncertain about formatting
      "info":"The worst book ever about the worst language.",
      "pic_url":[ 
      "www.ouramazons3server.com/23412341234",
      ...
      ]
      "post_craig":True,
      "post_facebook":False,
      "post_fof":False,
      "price":50,
      "status":"Sold"
    }

<a name="user"</a>
### User

A user (buyer/seller)

| Field             | Type    | Description                         |
| :----             | :---    | :----------                         |
| id                | Integer | The id for this user                |
| address_id        | Integer | Address_id of the user              |
| username          | String  | Username for the user               |
| first_name        | String  | First name of the user              |
| last_name         | String  | Last name of the user               |
| rating            | Integer | Rating for the user                 |
| info              | String  | Info/Description of the user        |
| avatar_url        | String  | Avatar url of the user              |

Example

    {
      "id": 4,
      "address_id": 5,
      "username":"dudedude",
      "first_name":"Bilbo",
      "last_name": "Baggins",
      "rating": 98,
      "info": "The coolest dude ever",
      "avatar_url": "www.ouramazons3server"
    }

<a name="message"</a>
### Message

A message sent between users, default or inquiry type

| Field             | Type    | Description                         |
| :----             | :---    | :----------                         |
| id                | Integer | The id for this message             |
| msg_chain_id      | Integer | The id of the owner msg_chain       |
| sender_id         | Integer | The id of the sender of the message |
| content           | String  | The content of the message          |
| type              | String  | The type (default/inquiry)          |
| date              | Date    | The date when message sent          |
| 

Example

    {
      "id": 4,
      "msg_chain_id": 5,
      "sender_id":1,
      "content": "hello, goodbye"
      "type": "default"
      "date":"11:59pm PST 11/11/11", // TODO(ryan):uncertain about formatting
    }

<a name="message-chain"</a>
### Message Chain

A message chain that is a list of messages 

| Field             | Type    | Description                         |
| :----             | :---    | :----------                         |
| id                | Integer | The id for this message chain       |
| msg_chain_id      | Integer | The id of the owner msg_chain       |
| sender_id         | Integer | The id of the sender of the message |
| content           | String  | The content of the message          |
| type              | String  | The type (default/inquiry)          |
| date              | Date    | The date when message sent          |
| 

Example

    {
      "id": 4,
      "msg_chain_id": 5,
      "sender_id":1,
      "content": "hello, goodbye"
      "type": "default"
      "date":"11:59pm PST 11/11/11", // TODO(ryan):uncertain about formatting
    }

