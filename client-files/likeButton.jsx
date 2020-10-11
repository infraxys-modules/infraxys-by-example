'use strict';

class LikeButtonJsx extends React.Component {

    constructor(props) {
        super(props);
        this.state = { liked: false };
    }

    render() {
        if (this.state.liked) {
            return 'You liked this - JSX.';
        }

        return React.createElement(
          'button',
          { onClick: () => this.setState({ liked: true }) },
          'Like - JSX button'
        );
    }
}

function createLikeButtonJsx(domContainer) {
    console.log("Initializing this button.");
    ReactDOM.render(React.createElement(LikeButtonJsx), domContainer);
}