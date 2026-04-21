import { BrowserRouter, Route, Routes } from "react-router-dom";
import AppLayout from "../layout/AppLayout";
import Home from "../pages/Home";
import SignIn from "../pages/SignIn";
import ProtectedRoute from "./ProtectedRoute";
import SignUp from "../pages/SignUp";
import AdminRoute from "./AdminRoute";
import AdminDashboard from "../pages/admin/AdminDashboard";
import AdminsPage from "../pages/admin/Admins";
import UsersPage from "../pages/admin/UsersPage";


function Router() {
  return (
    <BrowserRouter>
      <Routes>
        <Route element={<ProtectedRoute />}>
          <Route element={<AppLayout />}>
            <Route index element={<Home />} />

            <Route element={<AdminRoute />}>
              <Route path="/admin" element={<AdminDashboard />} />
              <Route path="/admin/admins" element={<AdminsPage />} />
              <Route path="/admin/users" element={<UsersPage />} />
              {/* <Route path="/admin/users/create" element={<UserFormPage />} /> */}
              {/* <Route path="/admin/users/:id/edit" element={<UserFormPage />} /> */}
            </Route>
          </Route>
        </Route>

        <Route path="/signin" element={<SignIn />} />
        <Route path="/signup" element={<SignUp />} />
      </Routes>
    </BrowserRouter>
  );
}


export default Router;

