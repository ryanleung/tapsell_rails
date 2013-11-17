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
    - [Sessions](#api-sessions)
        - [Login](#api-sessions-login)
        - [Logout](#api-sessions-logout)
    - [Address](#api-address)
        - [Create](#api-address-create)
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


<a name="general_information"></a>
## General API Information

This API spec serves as the API doc for v3 of the Luvocracy API focusing on components needed for the mobile application.

__Staging Base URL__

    https://www-staging.luvocracy.com/api/v3

__Production Base URL__

    https://www.luvocracy.com/api/v3

<a name="authentication"></a>
## Authentication

Authentication in the V3 API is straightforward:

   - Authenticate using the [Login Session API](#api-sessions-login). If successful, the response JSON includes a data.v3_api_token field.
   - Subsequent requests should include the token in the header.

__Authentication Token__

    X-LuvoApiV3Token

<a name="api"></a>
# API
