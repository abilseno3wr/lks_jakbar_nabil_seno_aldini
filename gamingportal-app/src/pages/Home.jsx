import { Link } from "react-router-dom";

function Home() {
  const username = localStorage.getItem("username") || "Guest";
  const isDeveloper = localStorage.getItem("isDeveloper") === "true";

  return (
    <>
      <div className="hero py-5 bg-light">
        <div className="container text-center">
          <h1 className="mb-0 mt-0">Dashboard</h1>
        </div>
      </div>

      <div className="list-form py-5">
        <div className="container">
          <h5 className="alert alert-info">Welcome, {username}.</h5>

          <div className="d-flex gap-2 flex-wrap">
            <Link to="/discover" className="btn btn-primary">
              Discover Games
            </Link>
            <Link to="/profile" className="btn btn-outline-primary">
              Open Profile
            </Link>
            {isDeveloper ? (
              <Link to="/manage-games" className="btn btn-outline-dark">
                Manage Your Games
              </Link>
            ) : null}
          </div>
        </div>
      </div>
    </>
  );
}

export default Home;
