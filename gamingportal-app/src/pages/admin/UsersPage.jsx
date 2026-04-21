import { useCallback, useEffect, useState } from "react";
import { Link } from "react-router-dom";
import api from "../../api/axios";

export default function UsersPage() {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  const loadUsers = useCallback(async () => {
    setError("");

    try {
      const response = await api.get("/users");
      setUsers(response.data.content || []);
    } catch (requestError) {
      setError(requestError.response?.data?.message || "Failed to load users");
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    loadUsers();
  }, [loadUsers]);

  const handleDelete = async (id, username) => {
    const confirmed = window.confirm(`Delete user ${username}?`);
    if (!confirmed) return;

    try {
      await api.delete(`/users/${id}`);
      setUsers((prev) => prev.filter((user) => user.id !== id));
    } catch (requestError) {
      setError(requestError.response?.data?.message || "Failed to delete user");
    }
  };

  return (
    <>
      <div className="hero py-5 bg-light">
        <div className="container">
          <Link to="/admin/users/create" className="btn btn-primary">
            Add User
          </Link>
        </div>
      </div>

      <div className="list-form py-5">
        <div className="container">
          <h6 className="mb-3">List Users</h6>

          {error ? <div className="alert alert-danger">{error}</div> : null}
          {loading ? <p>Loading...</p> : null}

          {!loading ? (
            <table className="table table-striped">
              <thead>
                <tr>
                  <th>Username</th>
                  <th>Created at</th>
                  <th>Last login</th>
                  <th>Status</th>
                  <th>Action</th>
                </tr>
              </thead>
              <tbody>
                {users.map((user) => {
                  const isBlocked = Boolean(user.deleted_at);

                  return (
                    <tr key={user.id}>
                      <td>
                        <a href={`/profile/${user.username}`} target="_blank" rel="noreferrer">
                          {user.username}
                        </a>
                      </td>
                      <td>{user.created_at || "-"}</td>
                      <td>{user.last_login_at || "-"}</td>
                      <td>
                        {isBlocked ? (
                          <span className="bg-danger text-white p-1 d-inline-block">Blocked</span>
                        ) : (
                          <span className="bg-success text-white p-1 d-inline-block">Active</span>
                        )}
                      </td>
                      <td>
                        <Link to={`/admin/users/${user.id}/edit`} className="btn btn-sm btn-secondary me-2">
                          Update
                        </Link>
                        <button
                          type="button"
                          className="btn btn-sm btn-danger"
                          onClick={() => handleDelete(user.id, user.username)}
                        >
                          Delete
                        </button>
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          ) : null}
        </div>
      </div>
    </>
  );
}
