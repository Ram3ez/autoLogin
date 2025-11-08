# NITPY Auto-Login

A cross-platform tool built by [**Ram3ez**](https://github.com/Ram3ez) to help NIT Puducherry students automatically log in to the institute's Wi-Fi captive portal. This project provides a mobile app (Flutter) and a desktop script (Python).

## 🚀 The Problem

Every time a student connects to the NITPY Wi-Fi, they have to open a browser, wait for the captive portal, and manually enter their username and password. This tool automates that entire process.

## ✨ Features

* **Cross-Platform Support:** Works on Android, iOS, Windows, macOS, and Linux.
* **One-Time Setup:** Enter your NITPY username and password just once.
* **Automatic Login:** Detects the captive portal and automatically submits your credentials.
* **Multiple Versions:** Choose from a user-friendly mobile app or a lightweight desktop script.

## 🏃 How to Use

Choose the method that works best for you. All downloads are available on the [Releases page](https://github.com/Ram3ez/autoLogin/releases).

### Method 1: Mobile App (Android & iOS)

This is the recommended method for the simplest, set-it-and-forget-it experience.

1.  **Download:** Go to the [**Releases page**](https://github.com/Ram3ez/autoLogin/releases).
    * Download `autoLogin.apk` for Android.
    * Download `autoLogin.ipa` for iOS.
2.  **Install:** Install the app on your device.
    * On Android, you may need to "Allow installation from unknown sources."
    * On iOS, you may need to trust the developer profile in your device settings.
3.  **Save Credentials:** Open the app and navigate to the **Settings** page.
4.  **Enter Details:** Enter your student username and password in the settings and tap "Save".
5.  **Done!** The next time you connect to the NITPY Wi-Fi, the app will use these saved credentials to log you in automatically.

### Method 2: Windows Executable (.exe)

For Windows users who want a simple desktop app without installing Python.

1.  **Download:** Go to the [**Releases page**](https://github.com/Ram3ez/autoLogin/releases) and download the `.exe` file (e.g., `autoLogin.exe`).
2.  **Run:** Place the `.exe` in a convenient folder (like your Desktop) and run it.
3.  **Enter Credentials:** The first time you run it, a console window will pop up asking for your username and password. They will be securely saved in a `config.json` file in the same folder.
4.  **Done!** Just run this `.exe` file anytime you connect to the Wi-Fi to log in.

**Note:** Windows Defender may flag this file. This is a common false positive for packaged Python scripts. If this happens, click **"More info" -> "Run anyway"**.

### Method 3: Python Script (Windows, macOS, Linux)

This is for advanced users or those on macOS/Linux. The script `autoLogin.py` is in the root of this repository.

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/Ram3ez/autoLogin.git](https://github.com/Ram3ez/autoLogin.git)
    cd autoLogin
    ```
2.  **Install dependencies:**
    ```bash
    pip install requests beautifulsoup4
    ```
3.  **Run the script:**
    ```bash
    python autoLogin.py
    ```
4.  **Enter Credentials:** The first time you run it, it will prompt for your credentials and save them to `config.json`.

## ⚠️ Disclaimer

This is an **unofficial** tool. It is a personal project and is not affiliated with or endorsed by NIT Puducherry or the Network Operating Centre (NOC).

Your credentials are stored on your device. Please be aware of the security implications of using third-party applications for authentication. Use at your own risk.

## 🤝 Contributing

Contributions are welcome! If you have an idea to improve the app, please feel free to fork the repository, make your changes, and open a Pull Request.

1.  Fork the Project
2.  Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the Branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

## 📄 License

This project is licensed under the MIT License.

**MIT License**

Copyright (c) 2025 Ram3ez

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the SOFTWARE, and to permit persons to whom the SOFTWARE is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the SOFTWARE.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOTT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
