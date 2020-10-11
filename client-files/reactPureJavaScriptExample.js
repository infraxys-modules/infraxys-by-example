
function react_code_onload(parentUrlEncoded, firstInvoke, jsonArg) {
    let loadedCount = 0;
    const readyAfter = 2;
    //const reactVersion = 'production.min';
    const reactVersion = 'development';
    const elementId = jsonArg['elementId'];

    console.log(`In react_code_only of react-pure-javascript-example. ElementId: ${elementId}, parentUrlEncoded: ${parentUrlEncoded}`);
    if (firstInvoke) {
        console.log('Loading React sources');

        function scriptLoaded() {
            loadedCount++;
            if (loadedCount === readyAfter) {
                initializeJavaScriptComponent(elementId, parentUrlEncoded);
            }
        }

        loadScript(`https://unpkg.com/react@16.13.1/umd/react.${reactVersion}.js`, scriptLoaded);
        loadScript(`https://unpkg.com/react-dom@16.13.1/umd/react-dom.${reactVersion}.js`, scriptLoaded);
    }
}

function loadScript(src, onload) {
    var reactScript = document.createElement('script');
    reactScript.src = src;
    document.head.appendChild(reactScript);
    reactScript.onload = onload;
}

function initializeJavaScriptComponent(elementId, parentUrlEncoded) {
    console.log('Initializing the JavaScript React component.');
    var component = document.createElement('script');
    component.src = `${parentUrlEncoded}/likeButtonJavaScript.js`;
    document.head.appendChild(component);

    component.onload = function () {
        console.log('Initializing the like-button.');
        const domContainer = document.getElementById(elementId);
        createLikeButton(domContainer);
    };
}
