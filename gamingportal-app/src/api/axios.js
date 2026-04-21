import axios from "axios";

const base_url = "http://localhost:8000/api/v1";

export const origin_api = base_url.replace(/\/api\/v1\/?$/, "");

let isHandlingAuthFailure = false;

const api = axios.create({
  baseURL: base_url,
});

api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem("token");

    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }

    return config;
  },
  (error) => Promise.reject(error),
);

api.interceptors.response.use(
  (response) => response,
  (error) => {
    const status = error?.response?.status;
    const payload = error?.response?.data || {};
    const url = error?.config?.url || "";
    const isLoginEndpoint = url.includes("/auth/signin");
    const isBlocked = status === 403 && payload?.status === "blocked";
    const isUnauthorized = status === 401;

    if ((isUnauthorized || isBlocked) && !isLoginEndpoint && !isHandlingAuthFailure) {
      isHandlingAuthFailure = true;

      if (isBlocked) {
        const reason =
          payload?.reason || payload?.message || "You have been blocked by an administrator";
        window.alert(reason);
      }

      localStorage.removeItem("token");
      localStorage.removeItem("username");
      localStorage.removeItem("isDeveloper");
      localStorage.removeItem("isAdministrator");
      window.dispatchEvent(new Event("auth:unauthorized"));

      setTimeout(() => {
        isHandlingAuthFailure = false;
      }, 0);
    }

    return Promise.reject(error);
  },
);

export default api;
