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

<a name="listing"></a>
### Listing

A listing posted by a seller

| Field             | Type    | Description                         |
| :----             | :---    | :----------                         |
| id                | Integer | The id for this listing             |
| address           | Address | The address for this listing        |
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

<a name="user"></a>
### User

A user (buyer/seller)

| Field             | Type    | Description                         |
| :----             | :---    | :----------                         |
| id                | Integer | The id for this user                |
| address           | Address | Address of the user                 |
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

<a name="message"></a>
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

Example

    {
      "id": 4,
      "msg_chain_id": 5,
      "sender_id":1,
      "content": "hello, goodbye"
      "type": "default"
      "date":"11:59pm PST 11/11/11", // TODO(ryan):uncertain about formatting
    }

<a name="message-chain"></a>
### Message Chain

A message chain that is a list of messages 

| Field             | Type    | Description                         |
| :----             | :---    | :----------                         |
| id                | Integer | The id for this message chain       |
| listing_id        | Integer | The id of the listing               |
| seller_id         | Integer | The id of the seller                |
| inquirer_id       | Integer | The id of the inquirer              |
| seller_dirty      | Bool    | If seller has read=>nondirty        |
| inquirer_dirty    | Bool    | If inquirer has read=>nondirty      |
| last_updated      | Date    | The date of last update             |
| messages[n]       | Message | List of messages in chain           |

Example

    {
      "id": 4,
      "listing_id": 5,
      "seller_id": 1,
      "inquirer_id": 3,
      "seller_dirty": True,
      "inquirer_dirty": False,
      "last_updated" = "11:59pm PST 11/11/11", // TODO(ryan):uncertain about formatting,
      "messages" = [
        message1,
        message2,
        ...
      ]
    }

<a name="api-sessions"></a>
<a name="api-sessions-login"></a>
## Sessions :: Login

Authenticates the user against the Tapsell server.

### Request

__POST__

    /sessions

#### Parameters

| Field                 | Type   | Description                           |
| :----                 | :---   | :----------                           |
| email                 | String | URL-encoded email address of the user |
| password              | String | URL-encoded password                  |
| facebook_access_token | String | URL-encoded fb access token           |

### Response

__Success (200)__

| Field             | Type   | Description                             |
| :----             | :---   | :----------                             |
| data.api_token    | String | The API token to use on future requests |
| data.user         | User   | The user                                |

Example

    HTTP/1.1 200 OK
    {
        "data": {
            "api_token": "API TOKEN"
        }
    }

__Error (4xx)__

| Field | Type   | Description              |
| :---- | :---   | :----------              |
| error | String | Description of the error |

Example

    HTTP/1.1 400 Bad Request
    {
        "error": "No email specified"
    }

<a name="api-sessions-logout"></a>
## Sessions :: Logout

Destroys the session the user has logged in with on Tapsell.

### Request

__Permissions__
    Requires authenticated token in the header.

__DELETE__

    /sessions

### RESPONSE

__Success (200)__

Example

    HTTP/1.1 200 OK

__Error (4xx)__

| Field | Type   | Description              |
| :---- | :---   | :----------              |
| error | String | Description of the error |

Example

    HTTP/1.1 401 Unauthorized
    {
        "error": "cannot destroy a non-authenticated session"
    }

<a name="api-address"></a>
<a name="api-address-create"></a>
## Address :: Create

### Request

Creates an address and ties it to either a listing or a user,
depending on which val is non-nil.

__Permissions__
    Authenticated User

__POST__

    /addresses

#### Parameters

| Field             | Type   | Description                         |
| :----             | :---   | :----------                         |
| listing_id        | Integer| Id of listing, nil if user-owned    |
| user_id           | Integer| Id of user, nilif listing-owned     |
| street_address    | String | The street address                  |
| extended_address  | String | Optional second line street address |
| locality          | String | The address city                    |
| region            | String | The address state                   |
| postal_code       | String | The address zip code                |
| phone             | String | The address phone number            |
| email             | String | The address e-mail address          |

Example

    {
      "listing_id": nil,
      "user_id": 2,
      "street_address":"123 Dude Street",
      "extended_address":"Unit #3833",
      "locality":"Dudetopia",
      "region":"North Carolina",
      "postal_code":"38337",
      "phone":"225-532-3833",
      "email":"dude@dudes.dude"
    }

### RESPONSE

__Success (200)__

Example

    HTTP/1.1 200 OK

__Error (4xx)__

| Field | Type   | Description              |
| :---- | :---   | :----------              |
| error | String | Description of the error |

Example

HTTP/1.1 400 Bad Request
    { 
        "error": "Address requires a first_name"
    }

<a name="api-credit-card"></a>
<a name="api-credit-card-create"></a>  

## Credit Card :: Create

Verifies a credit card with braintree and creates a credit card

### Request

__Permissions__

    Authenticated User

__POST__

    /credit_cards

##### Parameters

| Field             | Type   | Description                                |
| :----             | :---   | :----------                                |
| enc_cc_number     | String | The encrypted credit card number           |
| enc_cc_month      | String | The encrypted credit card expiration month |
| enc_cc_year       | String | The encrypted credit card expiration year  |
| venmo_sdk_session | String | The venmo encrypted session token          | 

Example

    {
        "enc_cc_number": "[Redacted]",
        "enc_cc_month": "[Redacted]",
        "enc_cc_year": "[Really Redacted]",
        "venmo_sdk_session": "[Redacted]",
    }

### Response

__Success(200)__

| Field           | Type    | Description                             |
| :----           | :---    | :----------                             |
| id              | Integer | The unique credit card id               |
| braintree_token | String  | A braintree generated identifier        |
| card_type       | String  | The credit card provider                |
| last_4          | String  | The last four digits of the credit card |

Example

    {
        "id": 4,
        "braintree_token": "abcdef",
        "card_type": "AMEX",
        "last_4": "4444"
    }

__Error (4xx)__

| Field | Type   | Description              |
| :---- | :---   | :----------              |
| error | String | Description of the error |

Example

    HTTP/1.1 400 Bad Request
    {
        "error": "Missing enc_cc_number parameter"
    }

<a name="api-facebook"></a>
<a name="api-facebook-friends"></a>

<a name="api-facebook-connect"></a>
## Facebook :: Connect Facebook

Connect a user's Facebook account to their Tapsell account.

### Request

__Permissions__
  Authenticated Tapsell Account

__POST__

    /connect_facebook

##### Parameters

| Field                 | Type   | Description                       |
| :----                 | :---   | :----------                       |
| facebook_access_token | String | Url-encoded facebook access token |

#### Response

__Success (200)__

Example

    HTTP/1.1 200 OK
    {
    }

__Error (4xx)__

| Field | Type   | Description              |
| :---- | :---   | :----------              |
| error | String | Description of the error |

Example

    HTTP/1.1 422 Unprocessable Entity
    {
        "error": "unable to connect facebook user"
    }

<a name="api-facebook-disconnect"></a>
## Facebook :: Disconnect Facebook

Disconnect a user's Facebook account from their Tapsell account.

### Request

__Permissions__
  Facebook-Authenticated Tapsell Account
  
__POST__

    /disconnect_facebook
    
##### Parameters

| Field                 | Type   | Description                       |
| :----                 | :---   | :----------                       |
| facebook_access_token | String | Url-encoded facebook access token |

#### Response

__Success (200)__

Example

    HTTP/1.1 200 OK
    {
    }

__Error (4xx)__

| Field | Type   | Description              |
| :---- | :---   | :----------              |
| error | String | Description of the error |

Example

    HTTP/1.1 422 Unprocessable Entity
    {
        "error": "unable to disconnect facebook user"
    }


