<template>
  <div class="av-config">
    <h2>AV 刮削设置</h2>
    <el-form :model="config" label-width="140px">
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
      <el-form-item label="开启翻译">
        <el-switch v-model="config.enable_translate" />
      </el-form-item>
      <el-form-item label="翻译引擎">
        <el-select v-model="config.translate_engine">
          <el-option label="Google 免费" value="google_free" />
          <el-option label="LibreTranslate" value="libretranslate" />
        </el-select>
      </el-form-item>
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
import { getAVConfig, saveAVConfig } from '@/api/avscrape'
import { ElMessage } from 'element-plus'

const config = ref({
  enable_metatube: true,
  metatube_server: 'https://metatube-server.hf.space',
  enable_javstash: false,
  javstash_api_key: '',
  enable_translate: false,
  translate_engine: 'google_free',
  prefer_chinese_source: true,
})

onMounted(async () => {
  const res = await getAVConfig()
  config.value = { ...config.value, ...res.data }
})

const saveConfig = async () => {
  await saveAVConfig(config.value)
  ElMessage.success('配置已保存')
}
</script>