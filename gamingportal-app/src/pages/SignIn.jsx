import { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import api from "../api/axios";

function SignIn() {
  const navigate = useNavigate();
  const [form, setForm] = useState({
    username: "",
    password: "",
  });
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);

  const handleChange = (event) => {
    setForm((prev) => ({
      ...prev,
      [event.target.name]: event.target.value,
    }));
  };

  const handleSubmit = async (event) => {
    event.preventDefault();
    setError("");
    setLoading(true);

    try {
      const response = await api.post("/auth/signin", form);
      const isAdministrator = Boolean(response.data.isAdministrator);

      localStorage.setItem("token", response.data.token);
      localStorage.setItem("username", response.data.username || form.username);
      localStorage.setItem("isDeveloper", String(Boolean(response.data.isDeveloper)));
      localStorage.setItem("isAdministrator", String(isAdministrator));

      window.dispatchEvent(new Event("auth:login"));
      navigate(isAdministrator ? "/admin" : "/");
    } catch (requestError) {
      setError(requestError.response?.data?.message || "Sign in failed");
    } finally {
      setLoading(false);
    }
  };

  return (
    <section className="login">
      <div className="container">
        <div className="row justify-content-center">
          <div className="col-lg-5 col-md-6">
            <h1 className="text-center mb-4">Gaming Portal</h1>
            <div className="card card-default">
              <div className="card-body">
                <h3 className="mb-3">Sign In</h3>

                <form onSubmit={handleSubmit}>
                  <div className="form-group my-3">
                    <label htmlFor="username" className="mb-1 text-muted">
                      Username
                    </label>
                    <input
                      type="text"
                      id="username"
                      name="username"
                      value={form.username}
                      onChange={handleChange}
                      className="form-control"
                      autoFocus
                    />
                  </div>

                  <div className="form-group my-3">
                    <label htmlFor="password" className="mb-1 text-muted">
                      Password
                    </label>
                    <input
                      type="password"
                      id="password"
                      name="password"
                      onChange={handleChange}
                      value={form.password}
                      className="form-control"
                    />
                  </div>

                  {error ? <div className="alert alert-danger">{error}</div> : null}

                  <div className="mt-4 row">
                    <div className="col">
                      <button type="submit" className="btn btn-primary w-100" disabled={loading}>
                        {loading ? "Signing In..." : "Sign In"}
                      </button>
                    </div>
                    <div className="col">
                      <Link to="/signup" className="btn btn-danger w-100">
                        Sign Up
                      </Link>
                    </div>
                  </div>
                </form>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}

export default SignIn;
