<template>
  <div class="av-config">
    <h2>AV 刮削设置</h2>
    <el-form :model="config" label-width="140px" style="max-width: 600px">
      <el-form-item label="启用 MetaTube">
        <el-switch v-model="config.enable_metatube" />
      </el-form-item>
      <el-form-item label="MetaTube 地址">
        <el-input v-model="config.metatube_server" placeholder="https://metatube-server.hf.space" />
      </el-form-item>

      <el-form-item label="启用 JavStash">
        <el-switch v-model="config.enable_javstash" />
      </el-form-item>
      <el-form-item label="JavStash API Key">
        <el-input v-model="config.javstash_api_key" type="password" show-password />
      </el-form-item>

      <el-divider content-position="left">评分</el-divider>

      <el-form-item label="启用 JavDB 评分">
        <el-switch v-model="config.enable_javdb_rating" />
      </el-form-item>
      <el-form-item label="JavDB API 端点" v-if="config.enable_javdb_rating">
        <el-input v-model="config.javdb_endpoint" placeholder="例如 https://jdforrepam.com" />
      </el-form-item>

      <el-divider content-position="left">翻译</el-divider>

      <el-form-item label="开启翻译">
        <el-switch v-model="config.enable_translate" />
      </el-form-item>
      <el-form-item label="翻译引擎">
        <el-select v-model="config.translate_engine" style="width: 100%">
          <el-option label="DeepL（推荐）" value="deepl" />
          <el-option label="必应翻译（Azure）" value="bing" />
          <el-option label="Google 免费" value="google_free" />
          <el-option label="MyMemory" value="mymemory" />
        </el-select>
      </el-form-item>
      <el-form-item label="DeepL API Key" v-if="config.translate_engine === 'deepl'">
        <el-input v-model="config.translate_deepl_key" placeholder="以 :fx 结尾" show-password />
      </el-form-item>
      <el-form-item label="必应 API Key" v-if="config.translate_engine === 'bing'">
        <el-input v-model="config.translate_bing_key" placeholder="Azure Translator KEY" />
      </el-form-item>
      <el-form-item label="必应 Region" v-if="config.translate_engine === 'bing'">
        <el-input v-model="config.translate_bing_region" placeholder="例如 eastasia" />
      </el-form-item>
      <el-form-item label="翻译目标语言">
        <el-input v-model="config.translate_target" placeholder="zh" />
      </el-form-item>

      <el-divider content-position="left">其他</el-divider>

      <el-form-item label="优先中文源">
        <el-switch v-model="config.prefer_chinese_source" />
      </el-form-item>

      <el-form-item>
        <el-button type="primary" @click="saveConfig">保存</el-button>
      </el-form-item>
    </el-form>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import axios from 'axios'
import { ElMessage } from 'element-plus'

interface AVConfig {
  enable_metatube: boolean
  metatube_server: string
  enable_javstash: boolean
  javstash_api_key: string
  enable_javdb_rating: boolean
  javdb_endpoint: string
  enable_translate: boolean
  translate_engine: string
  translate_deepl_key: string
  translate_bing_key: string
  translate_bing_region: string
  translate_target: string
  prefer_chinese_source: boolean
}

const config = ref<AVConfig>({
  enable_metatube: true,
  metatube_server: 'https://metatube-server.hf.space',
  enable_javstash: false,
  javstash_api_key: '',
  enable_javdb_rating: false,
  javdb_endpoint: '',
  enable_translate: false,
  translate_engine: 'deepl',
  translate_deepl_key: '',
  translate_bing_key: '',
  translate_bing_region: '',
  translate_target: 'zh',
  prefer_chinese_source: true,
})

const loadConfig = async () => {
  try {
    const res = await axios.get('/api/avscrape/config')
    config.value = { ...config.value, ...res.data }
  } catch (e) {
    ElMessage.error('加载配置失败')
  }
}

const saveConfig = async () => {
  try {
    await axios.post('/api/avscrape/config', config.value)
    ElMessage.success('配置已保存')
  } catch (e) {
    ElMessage.error('保存失败')
  }
}

onMounted(loadConfig)
</script>

<style scoped>
.av-config {
  padding: 20px;
}
</style>
