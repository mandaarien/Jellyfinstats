# =====================
# Jellyfin Stats Display for Tidbyt
# Displays active sessions, media library sizes, and latest media
# Version 1.0.0
# =====================

load("animation.star", "animation")
load("encoding/base64.star", "base64")
load("http.star", "http")
load("render.star", "render")
load("schema.star", "schema")
load("math.star", "math")

# ==========================
# Image Assets
# ==========================

IMAGES = {
    "icon.png": """iVBORw0KGgoAAAANSUhEUgAAABYAAAAUCAYAAACJfM0wAAAAAXNSR0IB2cksfwAAAARnQU1BAACxjwv8YQUAAAAgY0hSTQAAeiYAAICEAAD6AAAAgOgAAHUwAADqYAAAOpgAABdwnLpRPAAAAAlwSFlzAAAuIwAALiMBeKU/dgAAAAd0SU1FB+kHAREIOAo8oE4AAAG1SURBVDjLrZRBSJRBFMd/G0uPIFBILCg2sMLAo3bwkoRdWgkUOnhILwUdJPSgd0W8eRCELl7y5iUwIjpJEN4K8SCCGMGSewiUvC3/Ply9POX5ubvuxg4M38zvzfvPm/nmPbikSZqTlEiapFlN0qyk49DfNkN0MCV62p/U45+pItoO7ACtjorAbR//AR6a2WEt4StV+FIQnTCzO8C8z28CC/9zBQPh2Msp24dg62tENCvplzsWJLWk7K2S9t2+1YjwVIgoH/j9MB4Oa17XI9oi6cAd1gJ/5Ww4sHVnRUlXLxOeDpH0OMtJOnT2V1Kb876wdqyW6PUQ7cfAl1Nv+F2wfXX2u1QqZaoJvwnOj53drZAciaQbbn8e+Gi1dzzl310z++bjoQoxZIE8gJl9AgrOL6R6VlIvcM/nK8H23rOsM7Bt4EuYrwLjQI+kTjPbidewGI7U32AyDQXfmfRVxKLy8vTP1yF6C3gR0LnilJF0XMFvE9gHvgP/Ar8GPALaga6Uz5GZZaPwD6C7CeV7zcyengknSZIpl8sjwDPf4EEDYtvABvDZzFbqqccdQK6G4E8z26u14wmbUat8NmUcSwAAAABJRU5ErkJggg==""",
    "icon_color.png": """iVBORw0KGgoAAAANSUhEUgAAABYAAAAUCAYAAACJfM0wAAAAAXNSR0IB2cksfwAAAARnQU1BAACxjwv8YQUAAAAgY0hSTQAAeiYAAICEAAD6AAAAgOgAAHUwAADqYAAAOpgAABdwnLpRPAAAAAlwSFlzAAAuIwAALiMBeKU/dgAAAwpJREFUOMu9lE9oVVcQxr9vznVhLXoLDXWlEf9QF1IrscVXwdCFG6NYRd08rcVY0Rei+WMWokZbRZNITFwVkxBSEEyyCQW7zKIvhbyKGpWA6CJZCqKIIu+8O+feuLj3JamaGF04cLiHM3N+zP3mzBDvsT/3D9UHwlPW8PeqjtQlzNFkNue1fUMNEdmiwoUqbLl4ZLhhrmDO5Li+N7tVhX9ZQ1hPkDeE9YjAsOJc23c3Pgrcl85+6YSPrKEfgzluDUutJ7CGzwuGK9pbyp5+sBQR0e0EvhMgIg7W/rFhWWBYqQKowA8E3R+scV86uz0kK1QIR3ZVdaQ6AeDMle+7VNilQqjh1r0nb2+bM7gvnf08ItpUAEeOTRC10/2BsFaFYwm8fftvI/PnBJ4A6pxwqRMiIiozHakXjdU5/8Sx/7rr6276V1rKXgSGlU4IFZY64fH3gvvS2S8i4lgiwY3DnanBWG/2OuF+FfYCQPf5dYOB8G8VIhDWbGq6788Kjoh6J/Q1LlgVADRW5/aExGYngAo3HzhxazcAqCBTLKQKamYE96azfkRmVIiQ7DnSmRpPsr2o8W9DBQgMmwBg4PTa8cCwR4UIDKvXtI/67wRHRJUKFmmsbRsAnD6a2+0EpXFmRThLd5wd2RVnzXYnhBP6Tnj4neBQeDAOwt1MR2oEABxZrvFFOEHyJdSwHAD+aVhzJzC8m2h96E2wd23f0DYlliQy9BcdobDZCR+FwkUhEzjxPAQGpp4f+lXwjQqXLr76YMvjX7+ebHUvFPxU1NAJckVHU+v6cQCXZ2sCNRx2yV0V7gQwBXbkxuRdomDYeupo7lLBSLa5df3YTMBvL48uDww3Fsi6olyB4Q//G0JXD/w7YY3AeoQ18cp7RHL2xHp8mDdU63GeNbKqYFiSnxZrp2Jhf145OdQ8Fdao4LwKPktadbJgKihRssTFTVM8S/bTF16FxMm3xuaFzPDCQPhjwXBt3mOZ9WRB3vAr63H19KzyHlEwvGcNn1mPL63h7YLhnUA4+OqXVS/xKew1NN5L2uhGQbYAAAAASUVORK5CYII=""",
    "background.png": """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""",
    "background_black.png": """iVBORw0KGgoAAAANSUhEUgAAAQAAAAAgCAYAAAD9qabkAAAAAXNSR0IB2cksfwAAAARnQU1BAACxjwv8YQUAAAAgY0hSTQAAeiYAAICEAAD6AAAAgOgAAHUwAADqYAAAOpgAABdwnLpRPAAAAAlwSFlzAAAuIwAALiMBeKU/dgAAAAd0SU1FB+kHAwsrF6T8BFsAAAN1SURBVHja7V3RbtswDCQjB3vr/v8zu4e9RBr3Iq8sQ9JuUkfGdAcIcW2jgQHzeEdRCtOxKET0s4+3PvTxW3DNnvtBADAX3onolxrvzudvc867N8Xl4IdYOgmsY1Gf3gAAgKgSUeujqvOijrlfs+Omjmk0AURBX9TDyMb9Be8DMBnYIQRNCnvGKQjAZnVRAX9l5iVRA1o1AMBsCkAHvVUE9lp14ozOQACcqQARKU6wF5X1Ge8CMLEFqIEdEDPIyP/1/qEEEEl/L9N7xAH5D8yKNdjZyeqZ5G+JKng5AdjMXxKJ4t0L+Q/MCnGUgJX/UV2gfuWLLi94EFYPtBDR0r2/VgPXQCVAAQCzy/+sHmAJQ6uE4QRgi3nX9VhE7LWiiAEAZieA6kh7L7m2QA3UMxBA5v+L8ftERCIiAgsATA52FDQFkj86N1wB2KD3Hs7z+5YoAGA26ED+E2R3rzagLcBpagCaEArlXYDedQCYJ/Uz6xpAY+Ya1AQ81XAqC1CckbUFewoBAKaCiHwq+nVLvFUn8IqFwxWAV913s3pnPW8aEAoAgB24r/x7NYCHsv/RCsBKFHHqA7YbMOobAIAZA75uHEfNQqeoAdhgvia2APP+AJD3/1Pi/f8NZm5DCUA1+exZBmx9P1qAgdkVQDWZXAw5RCTRiKj1OsI4AlCSXg/ZUAkeSQDA7ERQkxrAjfypwFNYAOtLsoaghfx1AAAwY9B/+uyS3lvkw05ibWcggGhOf2tqEABm9/93JBDMBD61C9ArCGBJsr5XN2B9P9YEAJNDEmLYmhocSgA2+8sGQRQiWvrioKL+xisAzKgAorbfSt8w5z+iBuDN73sW4QI7AIAA0p2A2g6FMNwCRC2/0bn1YZ5qZgCA/8T/r4U/VjGh4yFrCGqPfPHRFkAHP+8gDEwBAigAfKwJaIYY9LkbPbAF2CsUgLYAdvnv1m8DYA0AMCOizK6r+80sFlrjS+iJRXRHTwOWHcGugx6rAYHpLQDFG3uwQxpf3gTkKALwCnwlGER+sxAKgMDMCkA21EHm/4dbAB34V5PV9YhqBZD/wLS2XwX73UIg1Q0YrQV4uHD+3RaAE1WwJCoBuwABkP/BvH/3/jeTUO3/GE4AmeQvSV3AY0IAmE3+R35eF9QzFXAKAoh2AbJdgRwQBxQAAHxk9T2/DfBUR+Bf8u72T1m+31QAAAAASUVORK5CYII=""",
}

# ============================
# Configurable fields in UI
# ============================
def get_schema():
    return schema.Schema(
        version = "1",
        fields = [
            schema.Text(
                id = "server_address_input",
                name = "Server Address",
                desc = "Server Address or IP with Port.",
                icon = "gear",
            ),
            schema.Text(
                id = "server_api_key",
                name = "API Key",
                desc = "Your Jellyfin personal access token.",
                icon = "key",
            ),
            schema.Toggle(
                id = "libraries_display",
                name = "Latest Media",
                desc = "Show Latest Media per Library.",
                icon = "display",
                default = True,
            ),
            schema.Text(
                id = "library_keywords",
                name = "Library Keywords",
                desc = "Additional keywords, comma-separated (e.g. documentaries, kids, action)",
                icon = "list",
            ),
            schema.Text(
                id = "library_blocked_keywords",
                name = "Library Exclude Keywords",
                desc = "Comma-separated list of terms to exclude (e.g. 'test, anime - filme')",
                icon = "x",
            ),
        ],
    )

# =============
# Main function
# =============
def main(config):
    # Get configuration values
    server_address = config.str("server_address_input", "------------> PUT SERVER URL HERE <------------")  
    api_key = config.str("server_api_key", "------------> PUT API KEY HERE <------------")  
    libraries_display = config.str("libraries_display", True)
    max_libraries = config.get("max_libraries", 3)

    if not server_address or not api_key:
        return render.Root(
            render.Text("Please configure"),
        )

    # Only load data if configuration is complete
    sessions = get_sessions(server_address, api_key)
    if type(sessions) != "list":
        return render.Root(child = render.Text("Session errors", font = "tom-thumb"))

    info = get_library_info(server_address, api_key)
    if type(info) != "dict":
        return render.Root(child = render.Text("Library error", font = "tom-thumb"))

    users = get_users(server_address, api_key)
    libraries = get_libraries(server_address, api_key, config)
    libraries = libraries[:max_libraries]
    libraries_delay = 70
    libraries_screens = []

    if libraries_display:
        for lib in libraries:
            libraries_screens.append(animation.Transformation(
                duration = 72,
                delay = libraries_delay,
                direction = "normal",
                fill_mode = "forwards",
                child = render_library_latest_tile(lib, server_address, api_key),
                keyframes = [
                    animation.Keyframe(
                        percentage = 0.0,
                        transforms = [animation.Translate(64, 0)],
                        curve = "ease_in_out",
                    ),
                    animation.Keyframe(
                        percentage = 0.4,
                        transforms = [animation.Translate(0, 0)],
                    ),
                    animation.Keyframe(
                        percentage = 0.8,
                        transforms = [animation.Translate(0, 0)],
                    ),
                    animation.Keyframe(
                        percentage = 1.0,
                        transforms = [animation.Translate(-64, 0)],
                    ),
                ],
            ))
            libraries_delay += 50

    # Calculate delays and durations in later steps depending on libraries displayed
    background_animation_black_percentaces = []

    if libraries_display:
        users_delay = libraries_delay
        outro_delay = users_delay + 25
        background_animation_black_duration = outro_delay + 25
        background_animation_black_percentaces = get_background_timings(background_animation_black_duration)
    else:
        users_delay = 125
        outro_delay = 25
        background_animation_black_duration = 250
        background_animation_black_percentaces = get_background_timings(background_animation_black_duration)

    # Display sequence steps
    children = []

    # ▶ Part 1: Intro, Background, Sessions
    children.extend([
        # Background Animation (NOT USED due to output file size limitations!!)
        # Background gradient moves
        animation.Transformation(
            duration = 50,
            direction = "alternate",
            fill_mode = "forwards",
            child = render.Image(src = base64.decode(IMAGES["background_black.png"])),
            keyframes = [
                animation.Keyframe(
                    percentage = 0.0,
                    transforms = [animation.Translate(-32, 0)],
                    curve = "ease_in_out",
                ),
                animation.Keyframe(
                    percentage = 1.0,
                    transforms = [animation.Translate(-160, 0)],
                ),
            ],
        ),
        # Background fades to black
        animation.Transformation(
            duration = background_animation_black_duration,
            delay = 10,
            direction = "normal",
            fill_mode = "forwards",
            child = render.Image(src = base64.decode(IMAGES["background_black.png"])),
            keyframes = [
                animation.Keyframe(
                    percentage = background_animation_black_percentaces[0],
                    transforms = [animation.Translate(64, 0)],
                    curve = "ease_in_out",
                ),
                animation.Keyframe(
                    percentage = background_animation_black_percentaces[1],
                    transforms = [animation.Translate(-160, 0)],
                ),
                animation.Keyframe(
                    percentage = background_animation_black_percentaces[2],
                    transforms = [animation.Translate(-160, 0)],
                ),
                animation.Keyframe(
                    percentage = background_animation_black_percentaces[3],
                    transforms = [animation.Translate(-256, 0)],
                ),
            ],
        ),
        # 1 Intro logo moves left off screen
        animation.Transformation(
            duration = 50,
            direction = "normal",
            fill_mode = "forwards",
            child = render.Row(
                main_align = "center",
                cross_align = "center",
                children = [
                    render.Image(src = base64.decode(IMAGES["icon_color.png"]), width = 22, height = 20),
                    render_server_info(server_address, api_key),
                ],
            ),
            keyframes = [
                animation.Keyframe(
                    percentage = 0.0,
                    transforms = [animation.Translate(2, 6)],
                    curve = "ease_in_out",
                ),
                animation.Keyframe(
                    percentage = 1.0,
                    transforms = [animation.Translate(-64, 6)],
                ),
            ],
        ),
        # 2 Stats slide in from right
        animation.Transformation(
            duration = 80,
            delay = 10,
            direction = "normal",
            fill_mode = "forwards",
            child = render_library_info(info),
            keyframes = [
                animation.Keyframe(
                    percentage = 0.0,
                    transforms = [animation.Translate(64, 1)],
                    curve = "ease_in_out",
                ),
                animation.Keyframe(
                    percentage = 0.4,
                    transforms = [animation.Translate(12, 1)],
                ),
                animation.Keyframe(
                    percentage = 0.8,
                    transforms = [animation.Translate(12, 1)],
                ),
                animation.Keyframe(
                    percentage = 1.0,
                    transforms = [animation.Translate(-64, 1)],
                ),
            ],
        ),
        # 2 Divider line appears from right
        animation.Transformation(
            duration = 80,
            delay = 10,
            direction = "normal",
            fill_mode = "forwards",
            child = render.Box(
                width = 60,
                height = 1,
                color = "#fff",
            ),
            keyframes = [
                animation.Keyframe(
                    percentage = 0.0,
                    transforms = [animation.Translate(64, 16)],
                    curve = "ease_in_out",
                ),
                animation.Keyframe(
                    percentage = 0.4,
                    transforms = [animation.Translate(2, 16)],
                ),
                animation.Keyframe(
                    percentage = 0.8,
                    transforms = [animation.Translate(2, 16)],
                ),
                animation.Keyframe(
                    percentage = 1.0,
                    transforms = [animation.Translate(-64, 16)],
                ),
            ],
        ),
        # 2 Sessions slide in from right
        animation.Transformation(
            duration = 80,
            delay = 10,
            direction = "normal",
            fill_mode = "forwards",
            child = render.Marquee(
                width = 60,
                offset_start = 0,
                offset_end = 0,
                child = render_sessions(sessions),
            ),
            keyframes = [
                animation.Keyframe(
                    percentage = 0.0,
                    transforms = [animation.Translate(64, 18)],
                    curve = "ease_in_out",
                ),
                animation.Keyframe(
                    percentage = 0.4,
                    transforms = [animation.Translate(2, 18)],
                ),
                animation.Keyframe(
                    percentage = 0.8,
                    transforms = [animation.Translate(2, 18)],
                ),
                animation.Keyframe(
                    percentage = 1.0,
                    transforms = [animation.Translate(-64, 18)],
                ),
            ],
        ),
    ])

    # ▶ Part 2: Latest media
    if libraries_display:
        children.extend(libraries_screens)

    # ▶ Part 3: Users and Outro
    children.extend([
        # 1 User grid slides in from right
        animation.Transformation(
            duration = 72,
            delay = users_delay,
            direction = "normal",
            fill_mode = "forwards",
            child = render_user_grid(users),
            keyframes = [
                animation.Keyframe(
                    percentage = 0.0,
                    transforms = [animation.Translate(64, 0)],
                    curve = "ease_in_out",
                ),
                animation.Keyframe(
                    percentage = 1.0,
                    transforms = [animation.Translate(-128, 0)],
                ),
            ],
        ),
        # 2 Final logo animation as outro
        animation.Transformation(
            duration = 50,
            delay = outro_delay,
            direction = "normal",
            fill_mode = "forwards",
            child = render.Row(
                main_align = "center",
                cross_align = "center",
                children = [
                    render.Image(src = base64.decode(IMAGES["icon_color.png"]), width = 22, height = 20),
                    render_server_info(server_address, api_key),
                ],
            ),
            keyframes = [
                animation.Keyframe(
                    percentage = 0.0,
                    transforms = [animation.Translate(64, 6)],
                    curve = "ease_in_out",
                ),
                animation.Keyframe(
                    percentage = 1.0,
                    transforms = [animation.Translate(2, 6)],
                ),
            ],
        ),
    ])

    # Combine and render all elements
    return render.Root(
        render.Stack(
            children = children,
        ),
    )

# ========================
# API function: Sessions
# ========================
def get_sessions(server_address, api_key):
    url = server_address + "/Sessions?api_key=" + api_key
    resp = http.get(url)

    if resp.status_code != 200:
        return "API error: " + str(resp.status_code)

    return resp.json()

# ==========================
# API function: Library Info
# ==========================
def get_library_info(server_address, api_key):
    url = server_address + "/Items/Counts?api_key=" + api_key
    resp = http.get(url)

    if resp.status_code != 200:
        return "API Error: " + str(resp.status_code)

    return resp.json()

# ==========================
# API function: Server Name
# ==========================
def get_server_name(server_address, api_key):
    url = server_address + "/System/Info/Public?api_key=" + api_key
    resp = http.get(url)
    if resp.status_code != 200:
        return "Unknown Server"

    data = resp.json()
    return data.get("ServerName", "Jellyfin")

# ==========================
# API function: Server Version
# ==========================
def get_server_version(server_address, api_key):
    url = server_address + "/System/Info/Public?api_key=" + api_key
    resp = http.get(url)

    if resp.status_code != 200:
        return {"name": "unknown", "Version": "10.10.x"}

    data = resp.json()
    return data.get("Version", "10.10.x")

# ==========================
# API function: Grab Users (only those with JPEG or PNG profile images)
# ==========================
def get_users(server_address, api_key):
    if not server_address or not api_key:
        # Dummy data: 4 example users with empty images
        return [
            {"name": "User A", "image_data": None},
            {"name": "User B", "image_data": None},
            {"name": "User C", "image_data": None},
            {"name": "User D", "image_data": None},
        ]
    url = server_address + "/Users?api_key=" + api_key
    resp = http.get(url)

    if resp.status_code != 200:
        return []

    users = resp.json()
    result = []

    for user in users:
        uid = user.get("Id", "")
        tag = user.get("PrimaryImageTag", "")
        name = user.get("Name", "???")

        if uid == "" or tag == "":
            continue

        image_url = (
            server_address + "/Users/" + uid + "/Images/Primary" +
            "?tag=" + tag +
            "&api_key=" + api_key +
            "&format=jpeg" +
            "&quality=90"
        )

        img_resp = http.get(image_url)
        if img_resp.status_code != 200:
            continue

        # Only accepted formats: JPEG or PNG
        content_type = img_resp.headers.get("Content-Type", "")
        if not (content_type.endswith("jpeg") or content_type.endswith("png")):
            continue

        img_data = img_resp.body()
        if img_data == None or len(img_data) < 100:
            continue

        result.append({
            "name": name,
            "image_data": img_data,
            "image_url": image_url,
        })

    return result

# ==========================
# API function: Latest Media from Libraries
# ==========================
def get_libraries(server_address, api_key, config):
    url = server_address + "/Library/MediaFolders?api_key=" + api_key
    resp = http.get(url)

    if resp.status_code != 200:
        return []

    # Standard allowed Keywords
    allowed_keywords = ["film", "filme", "movies", "serie", "series", "tv", "anime", "doku", "docu"]

    # Additional allowed Keywords from config
    extra_keywords_raw = config.get("library_keywords", "")
    if extra_keywords_raw:
        extra_keywords = []
        for kw in extra_keywords_raw.split(","):
            extra_keywords.append(kw.strip().lower())
        allowed_keywords.extend(extra_keywords)

    # Blocked Keywords – Standard + from config
    blocked_keywords = ["filme - anime ", "test", "beispiel"]
    blocked_keywords_raw = config.get("library_blocked_keywords", "")
    if blocked_keywords_raw:
        for bk in blocked_keywords_raw.split(","):
            blocked_keywords.append(bk.strip().lower())

    all_libraries = resp.json().get("Items", [])
    valid_libraries = []

    for lib in all_libraries:
        name = lib.get("Name", "").lower()

        # check blocked
        should_block = False
        for blocked in blocked_keywords:
            if blocked in name:
                should_block = True
                break
        if should_block:
            continue

        # check allowed
        for keyword in allowed_keywords:
            if keyword in name:
                valid_libraries.append(lib)
                break

    return valid_libraries

# ======================================
# Gets a single latest item from a library
# ======================================
def get_latest_item_from_library(server_address, api_key, library_id):
    url = (
        server_address + "/Items" +
        "?ParentId=" + library_id +
        "&SortBy=DateCreated" +
        "&SortOrder=Descending" +
        "&Limit=1" +
        "&Recursive=true" +
        "&Filters=IsNotFolder" +
        "&api_key=" + api_key
    )

    resp = http.get(url)
    if resp.status_code != 200:
        return None

    items = resp.json().get("Items", [])
    return items[0] if len(items) > 0 else None

# ======================================
# Render latest media tile for a library
# ======================================

def render_library_latest_tile(library, server_address, api_key):
    name = library.get("Name", "?")
    lib_id = library.get("Id", "")

    latest = get_latest_item_from_library(server_address, api_key, lib_id)
    if latest == None:
        return render.Text(name + ": No new Media", font = "CG-pixel-3x5-mono")

    title = latest.get("Name", "?")
    img = None

    # Bild laden
    img_url = get_primary_image_url(server_address, api_key, latest)
    if img_url:
        img_resp = http.get(img_url)
        if img_resp.status_code == 200:
            data = img_resp.body()
            if data and len(data) > 100:
                img = data
    return render.Row(
        children = [
            render.Image(src = img, width = 24, height = 32) if img else render.Box(width = 24, height = 32),
            render.Column(
                children = [
                    render.Padding(
                        pad = 1,
                        child =
                            render.Text("NEW", font = "CG-pixel-3x5-mono", color = "#8a6ac7"),
                    ),
                    render.Padding(
                        pad = (1, 0, 0, 0),
                        child =
                            render.Box(
                                width = 38,
                                height = 1,
                                color = "#fff",
                            ),
                    ),
                    render.Padding(
                        pad = (1, 1, 0, 0),
                        child =
                            render.WrappedText(
                                content = title,
                                font = "CG-pixel-3x5-mono",
                                width = 38,
                            ),
                    ),
                ],
            ),
        ],
    )

# ======================================
# Determine preview image to use per media
# ======================================
def get_primary_image_url(server, api_key, item):
    item_id = item.get("Id", "")
    image_tag = ""

    # 1. If episode: use the series image
    if image_tag == "":
        image_tag = item.get("SeriesPrimaryImageTag", "")
        item_id = item.get("SeriesId", item_id)

    # 2. Direct primary image
    image_tag = item.get("ImageTags", {}).get("Primary", "")

    # 3. If still empty, try ParentThumb
    if image_tag == "":
        image_tag = item.get("ParentThumbImageTag", "")
        item_id = item.get("ParentThumbItemId", item_id)

    if image_tag == "":
        return None

    return (
        server + "/Items/" + item_id + "/Images/Primary" +
        "?tag=" + image_tag +
        "&quality=80" +
        "&api_key=" + api_key
    )

# ======================================
# Render server info for Intro/Outro
# ======================================
def render_server_info(server_address, api_key):
    return render.Column(
        main_align = "start",
        children = [
            render.Marquee(
                width = 36,
                offset_start = 0,
                offset_end = 0,
                child = render.Text("" + str(get_server_name(server_address, api_key)), font = "Dina_r400-6"),
            ),
            render.Text("" + str(get_server_version(server_address, api_key)), font = "CG-pixel-3x5-mono", color = "#ffffff"),
        ],
    )

# ======================================
# Render user images (up to 14 total, randomly sampled if more exist)
# ======================================

def render_user_grid(users):
    max_users = 14

    # If more than max_users exist, randomly select 14
    if len(users) > max_users:
        users = math.sample(users, max_users)

    rows = []
    for i in range(0, len(users), 4):  # 4 images per row
        row_items = []
        for j in range(4):
            if i + j >= len(users):
                break
            img = users[i + j].get("image_data", None)
            if img:
                row_items.append(render.Image(src = img, width = 16, height = 16))
        if len(row_items) > 0:
            rows.append(render.Row(children = row_items))

    if len(rows) == 0:
        return render.Text("No working User Images")

    return render.Column(children = rows)

# ======================================
# Render currently active playback sessions
# ======================================
def render_sessions(sessions):
    items = []
    index = 1

    for s in sessions:
        item = s.get("NowPlayingItem", None)
        if item == None:
            continue  # Session is not active

        title = item.get("Name", "Unknown medium")
        series = item.get("SeriesName", "")

        # Show series names before the title if necessary
        if series != "" and series != title:
            title = series + ": " + title

        # Format: "1: Alice – Stranger Things"
        # line = str(index) + ": " + user + " – " + title
        line = str(index) + ": " + title
        items.append(render.Text(line, font = "tom-thumb"))
        index += 1

    # Fallback if no active sessions
    if len(items) == 0:
        items.append(
            render.Padding(
                pad = 1,
                child = render.Row(
                    children = [
                        render.Text("   0 Streams  ", font = "tom-thumb"),
                    ],
                ),
            ),
        )
    return render.Column(children = items)

# ======================================
# Render media library statistics
# ======================================
def render_library_info(info):
    return render.Column(
        children = [
            render.Padding(
                pad = 1,
                child = render.Row(
                    children = [
                        render.Text("Movies: ", font = "CG-pixel-3x5-mono"),
                        render.Text(str(int(info.get("MovieCount", 0))), font = "CG-pixel-3x5-mono", color = "#8a6ac7"),
                    ],
                ),
            ),
            render.Padding(
                pad = 1,
                child = render.Row(
                    children = [
                        render.Text(" Shows: ", font = "CG-pixel-3x5-mono"),
                        render.Text(str(int(info.get("SeriesCount", 0))), font = "CG-pixel-3x5-mono", color = "#8a6ac7"),
                    ],
                ),
            ),
        ],
    )

# ======================================
# Compute background animation keyframe timings
# ======================================
def get_background_timings(duration):
    p1 = 0.0
    p2 = float(50) / float(duration)  # corresponds to 50ms as a proportion
    p3 = 1.0 - (float(25) / float(duration))  # corresponds to 25ms as a proportion
    p4 = 1.0
    return [p1, p2, p3, p4]
