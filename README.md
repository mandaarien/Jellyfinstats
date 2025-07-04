# JellyfinStats for Tidbyt / [Tronbyt Server](https://github.com/tavdog/tronbyt-server)

⚠️ I currently use the script via HomeAssistant with [TidbytAssistant](https://github.com/savdagod/TidbytAssistant) for automations. I have not yet released it in the Tidbyt Community.

This Pixlet applet displays Jellyfin statistics on a Tidbyt device. It provides a quick and visual overview of:

- ▶️ Active playback sessions  
- 🎞️ Media library statistics (e.g., number of movies and shows)  
- 🆕 Latest media entries per library  
- 🧑‍🤝‍🧑 User profile image grid

## Preview

![JellyfinStats Preview](preview.gif)

## Features

- ✅ Displays total number of movies and shows
- ✅ Animated transitions between sections
- ✅ Latest media shown per allowed library
- ✅ User avatars with profile images (up to 14)
- ✅ Configurable via Tidbyt app interface

## Configuration

The following fields are available in the app settings:

| Field | Description |
|-------|-------------|
| **Server Address** (Required) | Your Jellyfin server URL (including protocol and port)  |
| **API Key** (Required) | Your personal Jellyfin API key |
| **Latest Media Toggle** | Show the newest item from each selected library |
| **Library Keywords** | Additional comma-separated keywords to include libraries (e.g. "kids, action") |
| **Library Exclude Keywords** | Keywords to exclude libraries (e.g. "test, anime - filme") |

## Filtering Logic

- Libraries must match **allowed keywords** (predefined or user-defined).
- Libraries are excluded if their names match any **blocked keywords**.
- Only libraries with valid image assets are displayed.

## Display Order

1. Server logo and name
2. Library statistics (up to 3)
3. Active playback sessions
4. Latest media (if enabled)
5. User avatars (up to 8)
6. Outro with server logo and name

## Image Fallback Strategy

For library item images:

1. If the item is an episode, use the series image.
2. Otherwise, use the item’s `PrimaryImageTag`.
3. As a last fallback, use `ParentThumbImageTag`.

## Limits

- GIF and Pixlet rendering are capped to 15 seconds of animation (and approx. 200KB ?).
- Maximum of **2 libraries** and **8 user avatars** displayed per run.
- If there are more than 2 libraries, a random subset is shown.
- If there are more than 8 users, a random subset is shown.
- User (Images) will only be shown, if the are PNG or JPEG on the server

## License

MIT
