import { Link, NavLink, Outlet, useLocation, useNavigate } from "react-router-dom";
import { useEffect, useRef, useState } from "react";
import "../css/bootstrap.css";
import "../css/style.css";
import api from "../api/axios";

function AppLayout() {
  const navigate = useNavigate();
  const location = useLocation();
  const mainRef = useRef(null);
  const [username, setUsername] = useState("");
  const [isDeveloper, setIsDeveloper] = useState(false);
  const [isAdministrator, setIsAdministrator] = useState(false);

  const onUnauthorized = () => {
    navigate("/signin", {
      replace: true,
      state: {
        from: location.pathname,
      },
    });
  };

  const loadAuthState = () => {
    setUsername(localStorage.getItem("username") || "");
    setIsDeveloper(localStorage.getItem("isDeveloper") === "true");
    setIsAdministrator(localStorage.getItem("isAdministrator") === "true");
  };

  useEffect(() => {
    window.addEventListener("auth:unauthorized", onUnauthorized);
    window.addEventListener("auth:login", loadAuthState);
    loadAuthState();

    return () => {
      window.removeEventListener("auth:unauthorized", onUnauthorized);
      window.removeEventListener("auth:login", loadAuthState);
    };
  }, []);

  useEffect(() => {
    mainRef.current?.scrollTo({ top: 0, left: 0, behavior: "auto" });
    window.scrollTo({ top: 0, left: 0, behavior: "auto" });
  }, [location.pathname, location.search]);

  const handleLogout = async () => {
    try {
      await api.post("/auth/signout");
    } catch {
      // If token is already invalid, continue local cleanup.
    }

    localStorage.removeItem("token");
    localStorage.removeItem("username");
    localStorage.removeItem("isDeveloper");
    localStorage.removeItem("isAdministrator");
    window.dispatchEvent(new Event("auth:unauthorized"));
  };

  return (
    <div style={{ height: "100vh", display: "flex", flexDirection: "column", overflow: "hidden" }}>
      <nav className="navbar navbar-expand-lg bg-primary navbar-dark">
        <div className="container">
          <Link className="navbar-brand" to={isAdministrator ? "/admin" : "/"}>
            {isAdministrator ? "Administrator Portal" : "Gaming Portal"}
          </Link>

          <ul className="navbar-nav ms-auto mb-2 mb-lg-0">
            {isAdministrator ? (
              <>
                <li>
                  <NavLink to="/admin/admins" className="nav-link px-2 text-white">
                    List Admins
                  </NavLink>
                </li>
                <li>
                  <NavLink to="/admin/users" className="nav-link px-2 text-white">
                    List Users
                  </NavLink>
                </li>
              </>
            ) : (
              <>
                <li>
                  <NavLink to="/discover" className="nav-link px-2 text-white">
                    Discover Games
                  </NavLink>
                </li>
                {isDeveloper ? (
                  <li>
                    <NavLink to="/manage-games" className="nav-link px-2 text-white">
                      Manage Games
                    </NavLink>
                  </li>
                ) : null}
                <li>
                  <NavLink to="/profile" className="nav-link px-2 text-white">
                    User Profile
                  </NavLink>
                </li>
              </>
            )}

            <li className="nav-item">
              <span className="nav-link active bg-dark rounded px-2">
                {username ? `Welcome, ${username}` : "Welcome"}
                {isDeveloper && !isAdministrator ? " (Developer)" : ""}
                {isAdministrator ? " (Administrator)" : ""}
              </span>
            </li>

            <li className="nav-item">
              <button onClick={handleLogout} className="btn bg-white text-primary ms-3">
                Sign Out
              </button>
            </li>
          </ul>
        </div>
      </nav>

      <main
        id="app-main-scroll"
        ref={mainRef}
        style={{
          flex: "1 1 auto",
          minHeight: 0,
          overflowY: "auto",
          overflowX: "hidden",
          overscrollBehaviorY: "contain",
          WebkitOverflowScrolling: "touch",
        }}
      >
        <Outlet />
      </main>
    </div>
  );
}

export default AppLayout;
