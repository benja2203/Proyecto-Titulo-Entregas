<template>
  <div>
    <VBtn prepend-icon="tabler-plus" @click="openCreateTicket">Agregar Ticket</VBtn>
  </div>

  <Transition name="fade">
    <div v-if="mostrarModal" class="modal-overlay">
      <div class="modal modal-right">
        <PerfectScrollbar :options="{ wheelPropagation: false }">
          <VCard flat>
            <VCardText>
              <VForm>
                <VRow>
                  <VCol cols="12">
                    <VTextField label="Título" v-model="titulo" variant="outlined" />
                  </VCol>

                  <VCol cols="12" md="6">
                    <VSelect label="Prioridad" v-model="prioridad" :items="prioridades" item-title="name" item-value="id"
                      variant="outlined" />
                  </VCol>

                  <VCol cols="12" md="6">
                    <VSelect label="Tipo de ticket" v-model="tipo" :items="tipos" item-title="name" item-value="id"
                      variant="outlined" />
                  </VCol>

                  <VCol cols="12">
                    <VSelect label="Categoría" v-model="categoria" :items="categorias" item-title="name" item-value="id"
                      variant="outlined" />
                  </VCol>

                  <VCol cols="12">
                    <label class="mb-1">Fecha realizar servicio</label>
                    <VMenu v-model="dateMenu" :close-on-content-click="false" transition="scale-transition" offset-y>
                      <template #activator="{ props }">
                        <VTextField v-bind="props" v-model="fechaLabel" variant="outlined" readonly
                          prepend-inner-icon="mdi-calendar" />
                      </template>
                      <VDatePicker v-model="fecha" @update:model-value="onPickFecha" hide-actions color="primary" />
                    </VMenu>
                  </VCol>

                  <VCol cols="12">
                    <VSelect v-model="asignado" :items="agentes" item-title="fullName" item-value="id" label="Asignar a"
                      variant="outlined" />
                  </VCol>

                  <!-- NUEVO CAMPO DIRECCIÓN -->
                  <VCol cols="12" md="12" class="position-relative">
                    <VTextField label="Dirección" v-model="direccionInput" variant="outlined" autocomplete="off"
                      @input="onInputDireccion" @blur="cerrarSuggestionsConDelay" :loading="loadingSuggestions" />
                    <ul v-if="direccionSuggestions.length" class="direccion-suggestions-list">
                      <li v-for="(item, index) in direccionSuggestions" :key="index"
                        @mousedown.prevent="selectDireccion(item)">
                        {{ item.properties.formatted }}
                      </li>
                    </ul>
                  </VCol>

                  <VCol cols="12">
                    <VTextarea label="Descripción (opcional)" v-model="descripcion" variant="outlined" />
                  </VCol>

                  <VCol cols="12">
                    <VBtn class="me-3" :loading="saving" :disabled="saving" @click="guardarTicket">Guardar</VBtn>
                    <VBtn variant="tonal" color="secondary" @click="cerrarModal">Cancelar</VBtn>
                  </VCol>
                </VRow>
              </VForm>
            </VCardText>
          </VCard>
        </PerfectScrollbar>
      </div>
    </div>
  </Transition>
</template>

<script>
import axios from 'axios'
import { computed, onMounted, ref } from 'vue'

const API = 'https://smarttechnical.up.railway.app'

export default {
  setup() {
    const mostrarModal = ref(false)
    const saving = ref(false)

    // Campos existentes
    const titulo = ref('')
    const prioridad = ref(null)
    const tipo = ref(null)
    const categoria = ref(null)
    const descripcion = ref('')

    // Fecha
    const dateMenu = ref(false)
    const fecha = ref(null)
    const fechaLabel = computed(() => {
      if (!fecha.value) return ''
      if (typeof fecha.value === 'string') return fecha.value
      const d = fecha.value; const y = d.getFullYear()
      const m = String(d.getMonth() + 1).padStart(2, '0')
      const day = String(d.getDate()).padStart(2, '0')
      return `${y}-${m}-${day}`
    })
    function onPickFecha() { dateMenu.value = false }

    // Catálogos y agentes
    const prioridades = ref([])
    const tipos = ref([])
    const categorias = ref([])
    const agentes = ref([])
    const asignado = ref(null)

    function normalize(x) {
      if (Array.isArray(x)) return x
      if (Array.isArray(x?.data)) return x.data
      if (Array.isArray(x?.results)) return x.results
      return []
    }

    async function loadCatalogs() {
      try {
        const [p, t, c] = await Promise.all([
          axios.get(`${API}/tickets_priority/`),
          axios.get(`${API}/tickets_type/`),
          axios.get(`${API}/tickets_category/`),
        ])
        prioridades.value = normalize(p.data)
        tipos.value = normalize(t.data)
        categorias.value = normalize(c.data)
      } catch (e) { console.error('[Catalogs]', e?.response ?? e) }
    }

    async function loadAgentes() {
      try {
        const { data } = await axios.get(`${API}/users/`)
        const list = normalize(data)
        agentes.value = list

          .map(u => ({ id: u.id, fullName: [u.name, u.last_name].filter(Boolean).join(' ') }))
      } catch (e) { console.error('[Agentes]', e?.response ?? e) }
    }

    function openCreateTicket() {
      mostrarModal.value = true
      if (!prioridades.value.length || !tipos.value.length || !categorias.value.length) loadCatalogs()
      if (!agentes.value.length) loadAgentes()
    }

    function cerrarModal() {
      mostrarModal.value = false
      titulo.value = ''
      prioridad.value = null
      tipo.value = null
      categoria.value = null
      descripcion.value = ''
      fecha.value = null
      asignado.value = null
      dateMenu.value = false
      direccionInput.value = ''
      direccionSuggestions.value = []
      loadingSuggestions.value = false
      direccionSeleccionada.value = null
      latitud.value = null
      longitud.value = null
    }

    function getLoggedUserId() {
      const raw = localStorage.getItem('userData')
      const userData = JSON.parse(raw || '{}')
      const userId = userData?.user?.id ?? userData?.id
      return userId ? Number(userId) : null
    }

    // Variables para autocompletado Geoapify
    const direccionInput = ref('')
    const direccionSuggestions = ref([])
    const loadingSuggestions = ref(false)
    const direccionSeleccionada = ref(null)
    const latitud = ref(null)
    const longitud = ref(null)
    let fetchTimeout = null

    async function fetchDireccionSuggestions() {
      if (fetchTimeout) clearTimeout(fetchTimeout)
      if (direccionInput.value.length < 3) {
        direccionSuggestions.value = []
        direccionSeleccionada.value = null // invalida selección si borra texto
        latitud.value = null
        longitud.value = null
        return
      }
      loadingSuggestions.value = true
      fetchTimeout = setTimeout(async () => {
        const url = `https://api.geoapify.com/v1/geocode/autocomplete?text=${encodeURIComponent(
          direccionInput.value
        )}&limit=5&apiKey=6993d291450645039f259b17a1ff6aa5`
        try {
          const response = await fetch(url)
          const data = await response.json()
          direccionSuggestions.value = data.features || []
        } catch (error) {
          console.error('Error al buscar sugerencias de dirección:', error)
        } finally {
          loadingSuggestions.value = false
        }
      }, 300)
    }

    function selectDireccion(item) {
      direccionInput.value = item.properties.formatted
      direccionSuggestions.value = []
      direccionSeleccionada.value = item // guardar selección válida
      // Extraer lat y lon (Geoapify usa [lon, lat])
      longitud.value = item.geometry.coordinates[0]
      latitud.value = item.geometry.coordinates[1]
    }

    function onInputDireccion() {
      direccionSeleccionada.value = null // invalida selección si el usuario escribe manualmente
      latitud.value = null
      longitud.value = null
      fetchDireccionSuggestions()
    }

    // Para evitar que se oculte la lista antes de seleccionar
    function cerrarSuggestionsConDelay() {
      setTimeout(() => {
        direccionSuggestions.value = []
      }, 200)
    }

    async function guardarTicket() {
      const currentUserId = getLoggedUserId()
      if (!currentUserId) {
        console.warn('Usuario no identificado')
        return
      }

      if (!titulo.value?.trim() || !prioridad.value || !tipo.value || !categoria.value || !asignado.value) {
        console.warn('Completa los campos obligatorios')
        return
      }

      if (!direccionSeleccionada.value || latitud.value === null || longitud.value === null) {
        alert('Por favor, seleccione una dirección válida desde el listado')
        return
      }

      const assignedId = typeof asignado.value === 'object' ? asignado.value.id : asignado.value

      const payload = {
        title: titulo.value.trim(),
        description: descripcion.value?.trim() || '',
        id_priority: prioridad.value,
        id_type: tipo.value,
        id_category: categoria.value,
        fecha_realizar_servicio: fechaLabel.value ? `${fechaLabel.value}T00:00:00` : null,
        id_managing_user: currentUserId,
        user_id: assignedId,
        id_status: 1,
        latitude: latitud.value,
        longitude: longitud.value,
      }

      saving.value = true
      try {
        const token = localStorage.getItem('accessToken')
        const headers = { 'Content-Type': 'application/json' }
        if (token) headers.Authorization = `Bearer ${token}`

        const { status, data } = await axios.post(`${API}/tickets/`, payload, { headers })
        cerrarModal()
      } catch (e) {
        console.error('[Ticket] error', e?.response?.status, e?.response?.data || e)
      } finally {
        saving.value = false
      }
      window.location.reload()
    }

    onMounted(() => {
      loadCatalogs()
      loadAgentes()
    })

    return {
      mostrarModal,
      openCreateTicket,
      cerrarModal,
      titulo,
      prioridad,
      tipo,
      categoria,
      descripcion,
      dateMenu,
      fecha,
      fechaLabel,
      onPickFecha,
      prioridades,
      tipos,
      categorias,
      agentes,
      asignado,
      saving,
      guardarTicket,
      direccionInput,
      direccionSuggestions,
      fetchDireccionSuggestions,
      selectDireccion,
      loadingSuggestions,
      cerrarSuggestionsConDelay,
      onInputDireccion,
    }
  },
}
</script>

<style>
.modal-overlay {
  position: fixed;
  z-index: 2000;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: rgba(0, 0, 0, 0.5);
  inset: 0;
}

.modal {
  padding: 20px;
  inline-size: 450px;
  transform: translateX(-37%);
}

.modal-right {
  margin-inline-start: 20%;
}

.direccion-suggestions-list {
  background-color: #1e1e2f;
  /* fondo oscuro similar a modal o tema oscuro */
  color: #eeeeee;
  /* texto claro */
  border: 1px solid #444;
  max-height: 160px;
  overflow-y: auto;
  list-style: none;
  padding-left: 0;
  margin-top: 4px;
  position: absolute;
  width: 100%;
  z-index: 3000;
  box-shadow: 0 4px 11px rgba(0, 0, 0, 0.3);
  border-radius: 6px;
}

.direccion-suggestions-list li {
  padding: 10px 12px;
  cursor: pointer;
  user-select: none;
}

.direccion-suggestions-list li:hover {
  background-color: #3a3a5a;
  /* hover más claro sobre fondo oscuro */
  color: white;
}
</style>

