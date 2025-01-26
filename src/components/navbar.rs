use crate::Route;
use dioxus::prelude::*;

//const NAVBAR_CSS: Asset = asset!("/assets/styling/navbar.css");
const NAVBAR_CSS: Asset = asset!("/assets/css/main.css");

#[component]
pub fn Navbar() -> Element {
    rsx! {
        document::Link { rel: "stylesheet", href: NAVBAR_CSS }

        div {
            id: "navbar",
            Link {
                to: Route::Home {},
                "news"
            }
            Link {
                to: Route::Home {},
                "contact"
            }
            // Link {
            //     to: Route::Blog { id: 1 },
            //     "Blog"
            // }
            div {
                id: "navbar-centered",
                Link {
                    to: Route::Home {},
                    "home"
                }

            }
            div {
                id: "navbar-right",
                Link {
                    to: Route::Home {},
                    "about"
                }
                Link {
                    to: Route::Home {},
                    "sign in"
                }
            }
        }


        Outlet::<Route> {}
    }
}
