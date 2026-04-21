import { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import api from "../api/axios";

export default function SignUp() {
  const [form, setForm] = useState({
    username: "",
    password: "",
  });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");
  const navigate = useNavigate();

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
      const response = await api.post("/auth/signup", form);
      localStorage.setItem("token", response.data.token);
      localStorage.setItem("username", response.data.username || form.username);
      localStorage.setItem("isDeveloper", "false");
      localStorage.setItem("isAdministrator", "false");
      window.dispatchEvent(new Event("auth:login"));
      navigate("/");
    } catch (requestError) {
      setError(requestError.response?.data?.message || "Sign up failed");
    } finally {
      setLoading(false);
    }
  };

  return (
    <>
      <div className="hero py-5 bg-light">
        <div className="container text-center">
          <h2 className="mb-3">Sign Up - Gaming Portal</h2>
        </div>
      </div>

      <div className="py-5">
        <div className="container">
          <div className="row justify-content-center ">
            <div className="col-lg-5 col-md-6">
              <form onSubmit={handleSubmit}>
                <div className="form-item card card-default my-4">
                  <div className="card-body">
                    <div className="form-group">
                      <label htmlFor="username" className="mb-1 text-muted">
                        Username <span className="text-danger">*</span>
                      </label>
                      <input
                        id="username"
                        value={form.username}
                        onChange={handleChange}
                        type="text"
                        placeholder="Username"
                        className="form-control"
                        name="username"
                      />
                    </div>
                  </div>
                </div>

                <div className="form-item card card-default my-4">
                  <div className="card-body">
                    <div className="form-group">
                      <label htmlFor="password" className="mb-1 text-muted">
                        Password <span className="text-danger">*</span>
                      </label>
                      <input
                        id="password"
                        value={form.password}
                        onChange={handleChange}
                        type="password"
                        placeholder="Password"
                        className="form-control"
                        name="password"
                      />
                    </div>
                  </div>
                </div>

                {error ? <div className="alert alert-danger">{error}</div> : null}

                <div className="mt-4 row">
                  <div className="col">
                    <button className="btn btn-primary w-100" disabled={loading}>
                      {loading ? "Signing Up..." : "Sign Up"}
                    </button>
                  </div>
                  <div className="col">
                    <Link to="/signin" className="btn btn-danger w-100">
                      Sign In
                    </Link>
                  </div>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
    </>
  );
}
