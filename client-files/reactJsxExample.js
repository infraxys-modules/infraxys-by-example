
function react_code_onload_jsx(parentUrlEncoded, firstInvoke, jsonArg) {
    let loadedCount = 0;
    let readyAfter = 3;
    //const reactVersion = 'production.min';
    const reactVersion = 'development';
    const elementId = jsonArg['elementId'];

    console.log(`In react_code_onload_jsx of react-jsx-example. ElementId: ${elementId}, parentUrlEncoded: ${parentUrlEncoded}`);
    if (firstInvoke) {
        console.log('Loading React sources');

        function scriptLoaded() {
            loadedCount++;
            if (loadedCount === readyAfter) {
                createJsxComponent(elementId, parentUrlEncoded);
            }
        }

        loadScript(`https://unpkg.com/react@16.13.1/umd/react.${reactVersion}.js`, '', scriptLoaded);
        loadScript(`https://unpkg.com/react-dom@16.13.1/umd/react-dom.${reactVersion}.js`, '', scriptLoaded);
        loadScript(`https://unpkg.com/@babel/standalone/babel.min.js`, 'module', scriptLoaded);
    }
}

function loadScript(src, type, onload) {
    var reactScript = document.createElement('script');
    reactScript.src = src;
    if (type !== '') {
        reactScript.type = type;
    }
    document.head.appendChild(reactScript);
    reactScript.onload = onload;
}

function createJsxComponent(elementId, parentUrlEncoded) {
    console.log("Creating JSX button.");
    var likeButton = document.createElement('script');
    likeButton.setAttribute('data-type', 'text/babel');
    likeButton.src = `${parentUrlEncoded}/likeButton.jsx`;
    document.head.appendChild(likeButton);

    likeButton.onload = function () {
        console.log('Initializing the JSX like-button.');
        const domContainer = document.getElementById(elementId);
        createLikeButtonJsx(domContainer);
    };
}
