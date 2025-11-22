<template>
  <div>

    <div class="map-container">
      <div class="map-wrapper">
        <GoogleMap api-key="AIzaSyBBI-D26YoQUTnXBNGrqQU0pAagnh0V1hw" style="width: 100%; height: 500px" :center="center"
          :zoom="15">
          <Marker v-for="marker in markers" :key="marker.id" :options="marker.options" />
        </GoogleMap>
      </div>
    </div>
    <v-table height="200px">
      <thead>
        <tr>
          <th>Identificador</th>
          <th>Nombre</th>
          <th>Fecha</th>
          <th>Dirección</th>
        </tr>
      </thead>
      <tbody>
        <template v-if="isLoading">
          <tr>
            <td colspan="4">Cargando usuarios...</td>
          </tr>
        </template>
        <template v-else>
          <tr v-for="user in users" :key="user.id">
            <td>{{ user.id_user }}</td>
            <td>
              <template v-if="userNames[user.id_user]">
                {{ userNames[user.id_user] }}
              </template>
              <template v-else>
                Cargando nombre...
              </template>
            </td>
            <td>{{ formatDate(user.updated_at) }}</td>
            <td>
              <template v-if="user.address">
                {{ user.address }}
              </template>
              <template v-else>
                Cargando dirección...
              </template>
            </td>
          </tr>
        </template>
      </tbody>
    </v-table>
  </div>
</template>

<script>
import axios from "axios";
import { defineComponent, onMounted, ref } from "vue";
import { GoogleMap, Marker } from "vue3-google-map";

export default defineComponent({
  components: { GoogleMap, Marker },
  setup() {
    const mostrarModal = ref(false);
    const isLoading = ref(false);
    const center = { lat: -33.45694, lng: -70.64827 };
    const markers = ref([]);
    const users = ref([]);
    const userNames = ref({});

    async function reverseGeocode(latitude, longitude) {
      const geocoder = new google.maps.Geocoder();
      const location = new google.maps.LatLng(parseFloat(latitude), parseFloat(longitude));
      return new Promise((resolve, reject) => {
        geocoder.geocode({ location: location }, (results, status) => {
          if (status === google.maps.GeocoderStatus.OK && results.length > 0) {
            resolve(results[0].formatted_address);
          } else {
            reject(status);
          }
        });
      });
    }

    async function fetchUserName(userId) {
      try {
        const response = await axios.get(`https://smarttechnical.up.railway.app/users/${userId}`);
        const user = response.data;
        return `${user.name} ${user.last_name}`;
      } catch (error) {
        console.error(error);
        return "";
      }
    }

    function formatDate(dateString) {
      const date = new Date(dateString);
      const day = date.getDate().toString().padStart(2, "0");
      const month = (date.getMonth() + 1).toString().padStart(2, "0");
      const year = date.getFullYear().toString();
      const hours = date.getHours().toString().padStart(2, "0");
      const minutes = date.getMinutes().toString().padStart(2, "0");
      const seconds = date.getSeconds().toString().padStart(2, "0");
      return `${hours}:${minutes}:${seconds} ${day}/${month}/${year} `;
    }

    async function submitForm() {
      // Realiza las acciones necesarias al enviar el formulario
      // ...

      // Cierra el modal
      mostrarModal.value = false;

      // Reinicia el formulario


      window.location.reload();
    }

    onMounted(async () => {
      isLoading.value = true;



      try {
        const response = await axios.get("https://smarttechnical.up.railway.app/position/");

        // ⬅️ Verificar si hay datos
        if (!response.data || !response.data || response.data.length === 0) {
          console.log('[Mapas] No hay posiciones registradas aún');
          users.value = [];
          markers.value = [];
          isLoading.value = false;
          return;
        }

        users.value = response.data;

        // Cargar nombres de usuarios
        for (const user of users.value) {
          const userName = await fetchUserName(user.id_user);
          userNames.value[user.id_user] = userName;
          console.log('usuarios traidos:', userNames.value);
        }

        // Convertir coordenadas a direcciones
        const userPromises = users.value.map(async (user) => {
          try {
            const address = await reverseGeocode(user.latitude, user.longitude);
            user.address = address;
          } catch {
            user.address = 'Dirección no disponible';
          }
        });
        await Promise.all(userPromises);

        // Crear marcadores
        const markerData = users.value
          .filter(user => user.latitude && user.longitude && user.latitude !== 0 && user.longitude !== 0)
          .map(user => ({
            id: user.id,
            options: {
              position: { lat: parseFloat(user.latitude), lng: parseFloat(user.longitude) },
              title: userNames.value[user.id_user] || 'Usuario',
              label: user.id_user.toString(),
            },
          }));

        markers.value = markerData;
        console.log('Marcadores creados:', markers.value);

      } catch (error) {
        console.error('[Mapas] Error cargando datos:', error);
        if (error.response && error.response.status === 404) {
          users.value = [];
          markers.value = [];
          console.log('[Mapas] No hay posiciones registradas (404)');
        }
      }

      isLoading.value = false;
    });

    return {
      center,
      markers,
      users,
      userNames,
      formatDate,
      mostrarModal,
      submitForm,
    };
  },
});
</script>

<style>
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 9999;
}

.modal {

  padding: 20px;
  border-radius: 5px;
  max-width: 500px;
  width: 400px;
}

.map-container {
  display: flex;
}

.map-wrapper {
  width: 100%;
  height: 500px;
}

table {
  width: 20%;
  margin-left: 20px;
}
</style>
