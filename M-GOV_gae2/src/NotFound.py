from Constants import errorMsg

## Return a service not found page
def main():
    print("Status: 404")
    print("Content-Type: text/html")
    print("<html><body>")
    print(errorMsg(200))
    print("</body></html>")

if __name__ == "__main__":
    main()