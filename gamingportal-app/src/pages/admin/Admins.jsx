import { useEffect, useState } from "react";
import api from "../../api/axios";

export default function AdminsPage() {
  const [admins, setAdmins] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  useEffect(() => {
    const loadAdmins = async () => {
      try {
        const response = await api.get("/admins");
        setAdmins(response.data.content || []);
      } catch (requestError) {
        setError(requestError.response?.data?.message || "Failed to load admin users");
      } finally {
        setLoading(false);
      }
    };

    loadAdmins();
  }, []);

  return (
    <>
      <div className="list-form py-5">
        <div className="container">
          <h6 className="mb-3">List Admin Users</h6>

          {error ? <div className="alert alert-danger">{error}</div> : null}
          {loading ? <p>Loading...</p> : null}

          {!loading ? (
            <table className="table table-striped">
              <thead>
                <tr>
                  <th>Username</th>
                  <th>Created at</th>
                  <th>Last login</th>
                </tr>
              </thead>
              <tbody>
                {admins.map((admin) => (
                  <tr key={admin.id}>
                    <td>{admin.username}</td>
                    <td>{admin.created_at || "-"}</td>
                    <td>{admin.last_login_at || "-"}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          ) : null}
        </div>
      </div>
    </>
  );
}
