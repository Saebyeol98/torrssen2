<template>
	<v-dialog
		v-if="showSetting"
		v-model="showSetting"
		persistent
		:max-width="$store.state.modalWidth"
    :fullscreen="windowWidth < $store.state.modalWidth"
	>
		<v-card>
      <v-toolbar flat extended>
        <v-btn icon @click="close">
          <v-icon>close</v-icon>
        </v-btn>
        <v-toolbar-title>환경 설정</v-toolbar-title>
        <template v-slot:extension>
          <v-spacer></v-spacer>
          <v-btn
            color="primary"
            flat="flat"
            @click="save(tabs)"
          >
            저장
          </v-btn>
        </template>
      </v-toolbar>
			<v-tabs>
				<v-tab
					v-for="(item, tabIndex) in tabs"
					v-model="currentItem"
					:key="tabIndex"
					:href="'#tab-' + tabIndex"
				>
					{{ item.name }}
				</v-tab>
				<v-tabs-items v-model="currentItem">
					<v-tab-item
						v-for="(item, tabIndex) in tabs"
						:key="tabIndex"
						:value="'tab-' + tabIndex"
					>
						<v-card-text>
							<v-container grid-list-md style="padding-top: 0; padding-bottom: 0">
								<v-layout wrap>
									<v-flex :xs12="item.type == 'text' || item.type == 'password' || item.type == 'app'"
                    :xs6="item.type == 'number' || item.type == 'boolean' || item.type == 'host'" 
                    v-show="item.type !== 'init'"
                    v-for="(item, index) in item.arr" :key="index">
										<v-text-field 
											v-if="item.type == 'text' || item.type == 'number' || item.type == 'password' || item.type == 'host'"
											v-model="item.value" 
											:label="item.label" 
											:type="item.type"
											:required="item.required"
										></v-text-field>
										<v-combobox 
											v-else-if="item.type == 'boolean' && item.key != 'DARK_THEME'"
											v-model="item.value" 
											:label="item.label" 
											:items="['TRUE', 'FALSE']"
											:required="item.required"
										></v-combobox>
                    <v-combobox 
											v-else-if="item.type == 'boolean' && item.key == 'DARK_THEME'"
											v-model="item.value" 
											:label="item.label" 
											:items="['TRUE', 'FALSE', 'AUTO']"
											:required="item.required"
										></v-combobox>
										<v-combobox 
											v-else-if="item.type == 'app'"
											v-model="item.value" 
											:label="item.label" 
											:items="['TRANSMISSION', 'DOWNLOAD_STATION']"
											:required="item.required"
										></v-combobox>
                    <v-btn
                      v-else-if="item.type == 'button'"
                      flat
                      block
                      @click="connTest(item.value, tabIndex)"
                    >
                      {{ item.label }}
                    </v-btn>
									</v-flex>
                  <template v-if="item.name === '로그인'">
                    <v-flex xs12 v-for="(item, index) in item.arr" :key="index">
                      <v-text-field 
                        v-model="user.username"
                        label="아이디" 
                        type="text"
                        :required="true"
                      ></v-text-field>
                    </v-flex>
                    <v-flex xs12 v-for="(item, index) in item.arr" :key="index">
                      <v-text-field 
                        v-model="user.password" 
                        label="비밀번호" 
                        type="password"
                        :required="true"
                      ></v-text-field>
                    </v-flex>
                  </template>
                  <template v-if="item.name === 'FEED 관리'">
                    <v-flex xs6></v-flex>
                    <v-select
                      v-model="selected" 
                      :items="siteList"
                      label="FEED를 삭제할 RSS 사이트"
                      multiple
                      chips
                    ></v-select>
                    <v-flex xs12 sm1 style="margin-top: 0.4rem">
                      <v-tooltip bottom>
                        <template v-slot:activator="{ on }">
                          <v-icon v-on="on" @click="deleteFeed">delete</v-icon>
                        </template>
                        <span>선택 항목 삭제</span>
                      </v-tooltip>
                    </v-flex>
                  </template>
								</v-layout>
							</v-container>
              <v-alert
                    :value="alertShow"
                    :type="alertType"
                    transition="scale-transition"
                  >
                    {{ alertMsg }}
                  </v-alert>
						</v-card-text>
            
					</v-tab-item>
				</v-tabs-items>
			</v-tabs>
		</v-card>
	</v-dialog>
</template>

<script>
import axios from '~/plugins/axios'

export default {
  data () {
    return {
      oris: [],
      tabs: [],
      selected: [],
      siteList: [],
      currentItem: 0,
      windowWidth: 0,
      user: {},
      oriUser: {},
      alertShow: false,
      alertType: '',
      alertMsg: ''
    }
  },
  computed: {
    showSetting: {
      get () {
        return this.$store.state.setting.showSetting
      },
      set (value) {
        this.$store.commit('setting/setShowSetting', value)
      }
    }
  },
  watch: {
    showSetting: function (val) {
      if (val === true) {
        this.tabs = []
        this.selected = []
        axios.get('/api/setting/list?sort=orderId,key').then(res => {
          this.oris = res.data
          let arr = []
          for (let i = 0; i < res.data.length; i++) {
            let obj = res.data[i]
            if (i > 0 && res.data[i - 1].groupLabel !== obj.groupLabel) {
              if (res.data[i - 1].groupLabel !== 'false') {
                this.tabs.push({
                  name: res.data[i - 1].groupLabel,
                  arr: JSON.parse(JSON.stringify(arr))
                })
                arr = []
              }
            }
            arr.push(obj)
          }
          if (arr.length > 0) {
            this.tabs.push({
              name: res.data[res.data.length - 1].groupLabel,
              arr: JSON.parse(JSON.stringify(arr))
            })
          }
        })
        this.siteList = []
        axios.get('/api/rss/rss-site/distinct').then(res => {
          this.siteList = res.data
        })
        this.user = {}
        axios.get('/api/user/admin').then(res => {
          if (res.data) {
            this.user = res.data
            this.oriUser = JSON.parse(JSON.stringify(res.data))
          } else {
            this.user = { username: '', password: '' }
            this.oriUser = { username: ' ', password: '' }
          }
        })
      }
    }
  },
  mounted () {
    this.windowWidth = window.innerWidth
  },
  methods: {
    close: function () {
      this.$store.commit('setting/setShowSetting', false)
    },
    save: function (tabs) {
      let items = []
      for (let i = 0; i < tabs.length; i++) {
        for (let j = 0; j < tabs[i].arr.length; j++) {
          for (let k = 0; k < this.oris.length; k++) {
            if (this.oris[k].key === tabs[i].arr[j].key && this.oris[k].value !== tabs[i].arr[j].value) {
              items.push(tabs[i].arr[j])
            } else if (tabs[i].arr[j].key === 'INIT' && tabs[i].arr[j].value === 'FALSE') {
              tabs[i].arr[j].value = 'TRUE'
              items.push(tabs[i].arr[j])
            }
          }
        }
      }
      for (let i = 0; i < items.length; i++) {
        if (items[i].key === 'INIT') {
          items[i].value = 'TRUE'
          break
        }
      }
      axios.post('/api/setting/save', items).then(res => {
        for (let key in this.oriUser) {
          if (this.user[key] !== this.oriUser[key]) {
            axios.post('/api/user/admin', this.user).then(res => {
              if (res.status !== 200) {
                msg = '저장하지 못했습니다.'
              }
            })
            break
          }
        }
        let msg = '저장하였습니다.'
        if (res.status !== 200) {
          msg = '저장하지 못했습니다.'
        }
        this.$store.commit('snackbar/show', msg)
        axios.get('/api/setting/DARK_THEME').then(res => {
          if (res.data === 'AUTO') {
            if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
              res.data = 'TRUE'
            } else {
              res.data = 'FALSE'
            }
          }
          this.$store.commit('setDark', res.data === 'TRUE')
        })
        this.close()
      })
    },
    deleteFeed: function () {
      if (confirm('삭제하시겠습니까?')) {
        axios.post('/api/rss/feed/delete/rss-site/list', this.selected).then(res => {
          let msg = '삭제하였습니다.'
          if (res.status !== 200) {
            msg = '삭제하지 못했습니다.'
          }
          this.$store.commit('snackbar/show', msg)
          this.$store.commit('toolbar/toggle')
        })
      }
    },
    connTest: function (val, tabIndex) {
      if (val === 'telegramTest') {
        let token, chatId
        console.log(this.tabs[tabIndex].arr)
        for (let i = 0; i < this.tabs[tabIndex].arr.length; i++) {
          let item = this.tabs[tabIndex].arr[i]
          if (item.key === 'TELEGRAM_TOKEN') {
            token = item.value
          } else if (item.key === 'TELEGRAM_CHAT_ID') {
            chatId = item.value
          }
        }
        axios.get('/api/setting/telegram-test', {
          params: {
            token: token,
            chatId: chatId
          }
        }).then(res => {
          this.alertMsg = res.data ? '접속 성공' : '접속 실패'
          this.alertType = res.data ? 'success' : 'error'
          this.alertShow = true
          setTimeout(() => {
            this.alertShow = false
          }, 3000)
        })
      } else {
        let host, port, id, pwd
        for (let i = 0; i < this.tabs[tabIndex].arr.length; i++) {
          let item = this.tabs[tabIndex].arr[i]
          if (item.key.includes('USERNAME')) {
            id = item.value
          } else if (item.key.includes('PASSWORD')) {
            pwd = item.value
          } else if (item.key.includes('HOST')) {
            host = item.value
          } else if (item.key.includes('PORT')) {
            port = item.value
          }
        }
        axios.get('/api/download/conn-test', {
          params: {
            app: val,
            host: host,
            port: port,
            id: id,
            pwd: pwd
          }
        }).then(res => {
          this.alertMsg = res.data ? '접속 성공' : '접속 실패'
          this.alertType = res.data ? 'success' : 'error'
          this.alertShow = true
          setTimeout(() => {
            this.alertShow = false
          }, 3000)
        })
      }
    }
  }
}
</script>