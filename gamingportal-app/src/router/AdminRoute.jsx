import { Navigate, Outlet, useLocation } from "react-router-dom";

export default function AdminRoute() {
  const location = useLocation();
  const isAdministrator = localStorage.getItem("isAdministrator") === "true";

  if (!isAdministrator) {
    return <Navigate to="/" replace state={{ from: location.pathname }} />;
  }

  return <Outlet />;
}
 
