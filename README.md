# Sense
<img src="https://github.com/AndreaBot/Sense/assets/128467098/76383890-4504-4d4b-9569-da7c5d9d9b21" alt="1024" width="180">

Sense was the final project I developed using UIKit.

This journaling app allows users to enter one entry in the morning and another in the evening.

Technologies used:
- Swift and UIKIt
- Firebase Auth
- Firebase Firestore
- API calls
- Local notifications
- UICalendarView

<img width="220" alt="Screenshot 2024-06-05 at 22 42 26" src="https://github.com/AndreaBot/Sense/assets/128467098/b5bfadfd-0b0d-48de-96da-aa6adcdbc9b4">

The launch screen features a daily quote, sourced from the Zen Quotes API (https://zenquotes.io).

The app's primary screens include sections for creating diary entries and revisiting past entries.

<img width="220" alt="Screenshot 2024-06-05 at 22 42 39" src="https://github.com/AndreaBot/Sense/assets/128467098/5381d091-ca70-4e95-b68d-de09307f7b25">  <img width="220" alt="Screenshot 2024-06-05 at 22 44 00" src="https://github.com/AndreaBot/Sense/assets/128467098/668655ba-cdbf-497e-a595-898d86b48223">  <img width="220" alt="Screenshot 2024-06-05 at 22 44 17" src="https://github.com/AndreaBot/Sense/assets/128467098/ab18608b-29d9-4948-83ca-0fe8b98e99af">

The "Morning Intentions" section is available from midnight until midday, allowing users to log their morning thoughts. Each diary entry includes:

- A mood tracker
- Today's positive intentions
- Top 3 to-dos
- A blank section for additional thoughts

The "Evening Reflections" section, accessible after midday, focuses on different aspects and includes:

- A mood tracker
- 3 things I did well today
- 3 things I could improve on
- A blank section for extra thoughts
  
The Calendar screen employs a UICalendarView, enabling users to review and modify past diary entries. Dates with at least one entry are highlighted with a pink dot
and the number of entries is revealed through a sheet. The database of choice is Firebase Firestore, allowing users to access their diary from multiple devices.

<img width="220" alt="Screenshot 2024-06-05 at 22 43 03" src="https://github.com/AndreaBot/Sense/assets/128467098/b14d2414-f445-4cbe-a825-509283ee3246"> <img width="220" alt="Screenshot 2024-06-06 at 21 07 15" src="https://github.com/AndreaBot/Sense/assets/128467098/da7aa162-9b9a-4bba-bc5b-636b1e27a4c4">

The app also features an option to enable reminders at specific times, triggering notifications so users don't forget to log their thoughts.
The notification messages are randomized, with five different variations for both the morning and evening notifications.

<img width="220" alt="Screenshot 2024-06-05 at 22 43 37" src="https://github.com/AndreaBot/Sense/assets/128467098/8edd6fdd-31e2-4d1a-9415-49e3758ccc3f"> <img width="440" alt="Screenshot 2024-06-06 at 21 11 03" src="https://github.com/AndreaBot/Sense/assets/128467098/c358fbe0-a75a-4b76-8d47-24179c72dd0f">



  
