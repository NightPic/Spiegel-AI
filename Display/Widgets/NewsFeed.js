/*document.addEventListener("DOMContentLoaded", function() {
    function fetchNewsFeed(rssUrl, numberOfItems) {
        const newsFeed = document.getElementById("news-feed");
        newsFeed.innerHTML = ''; // Clears the existing content

        fetch(rssUrl)
            .then(response => response.text())
            .then(str => new window.DOMParser().parseFromString(str, "text/xml"))
            .then(data => {
                const items = data.querySelectorAll("item");
                for (let i = 0; i < Math.min(numberOfItems, items.length); i++) {
                    let item = items[i];
                    let title = item.querySelector("title").textContent;
                    let link = item.querySelector("link").textContent;

                    const li = document.createElement("li");
                    const a = document.createElement("a");
                    a.href = link;
                    a.target = "_blank";
                    a.textContent = title;
                    li.appendChild(a);
                    newsFeed.appendChild(li);
                }
            })
            .catch(error => console.error("Error fetching the RSS feed:", error));
    }

    // Beispielaufruf der Funktion mit NYT RSS-Feed und 2 Elementen
    const rssUrl = "https://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml";
    fetchNewsFeed(rssUrl, 2);
});
*/

document.addEventListener("DOMContentLoaded", function() {
    function fetchNewsFeed(rssUrl, numberOfItems) {
        const newsFeed = document.getElementById("news-feed");
        newsFeed.innerHTML = ''; // Löscht den vorhandenen Inhalt

        fetch(`https://api.rss2json.com/v1/api.json?rss_url=${rssUrl}`)
            .then(response => response.json())
            .then(data => {
                const items = data.items;
                for (let i = 0; i < Math.min(numberOfItems, items.length); i++) {
                    let item = items[i];
                    let title = item.title;
                    let link = item.link;

                    const li = document.createElement("li");
                    const a = document.createElement("a");
                    a.href = link;
                    a.target = "_blank";
                    a.textContent = title;
                    li.appendChild(a);
                    newsFeed.appendChild(li);
                }
            })
            .catch(error => console.error("Fehler beim Abrufen des RSS-Feeds:", error));
    }

    // Die URL des RSS-Feeds der Frankfurter Allgemeinen Zeitung
    const rssUrl = "https://www.faz.net/rss/aktuell/";
    fetchNewsFeed(rssUrl, 2); // Zeigt die neuesten 5 Nachrichten an
});

function RefreshNews(){
    fetchNewsFeed(rssUrl, 2);
}


