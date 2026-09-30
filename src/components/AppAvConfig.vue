<template>
  <div class="av-config">
    <h2>AV 刮削设置</h2>
    <el-form :model="config" label-width="170px" style="max-width: 760px">
      <el-divider content-position="left">数据源</el-divider>

      <el-form-item label="启用 MetaTube">
        <el-switch v-model="config.enable_metatube" />
      </el-form-item>
      <el-form-item label="MetaTube 地址" v-if="config.enable_metatube">
        <el-input v-model="config.metatube_server" placeholder="https://metatube-server.hf.space" />
      </el-form-item>
      <el-form-item label="启用 JavStash">
        <el-switch v-model="config.enable_javstash" />
      </el-form-item>
      <el-form-item label="JavStash API Key" v-if="config.enable_javstash">
        <el-input v-model="config.javstash_api_key" type="password" show-password />
      </el-form-item>
      <el-form-item label="优先中文源">
        <el-switch v-model="config.prefer_chinese_source" />
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
      <el-form-item label="翻译引擎" v-if="config.enable_translate">
        <el-select v-model="config.translate_engine" style="width: 100%">
          <el-option label="Gemini AI（推荐，翻译质量最好）" value="gemini" />
          <el-option label="DeepL（免费版，每月 50 万字符）" value="deepl" />
          <el-option label="必应翻译（Azure）" value="bing" />
          <el-option label="Google 免费" value="google_free" />
          <el-option label="MyMemory" value="mymemory" />
        </el-select>
      </el-form-item>

      <template v-if="config.enable_translate && config.translate_engine === 'gemini'">
        <el-form-item label="Gemini API Key">
          <el-input v-model="config.translate_gemini_key" type="password" show-password
                    placeholder="从 Google AI Studio 获取，通常以 AIza 或 AQ. 开头" />
        </el-form-item>
        <el-form-item label="Gemini 模型">
          <el-select v-model="config.translate_gemini_model" style="width: 100%">
            <el-option label="gemini-3.8-flash（推荐，速度快）" value="gemini-3.8-flash" />
            <el-option label="gemini-3.1-pro-preview（更聪明，慢一点）" value="gemini-3.1-pro-preview" />
          </el-select>
        </el-form-item>
      </template>

      <el-form-item label="DeepL API Key"
                    v-if="config.enable_translate && config.translate_engine === 'deepl'">
        <el-input v-model="config.translate_deepl_key" placeholder="以 :fx 结尾" show-password />
      </el-form-item>

      <template v-if="config.enable_translate && config.translate_engine === 'bing'">
        <el-form-item label="必应 API Key">
          <el-input v-model="config.translate_bing_key" placeholder="Azure Translator KEY" />
        </el-form-item>
        <el-form-item label="必应 Region">
          <el-input v-model="config.translate_bing_region" placeholder="例如 eastasia" />
        </el-form-item>
      </template>

      <el-form-item label="翻译目标语言" v-if="config.enable_translate">
        <el-input v-model="config.translate_target" placeholder="zh" />
      </el-form-item>

      <el-divider content-position="left">附加标签（作为 tag 写入 NFO）</el-divider>

      <el-form-item label="分辨率标签">
        <el-switch v-model="config.extra_tag_resolution" />
        <span class="hint">（ffprobe 读取，生成 4K/1080p 等 tag）</span>
      </el-form-item>
      <el-form-item label="有码/无码标签">
        <el-switch v-model="config.extra_tag_uncensored" />
        <span class="hint">（按番号前缀判断）</span>
      </el-form-item>
      <el-form-item label="中文字幕标签">
        <el-switch v-model="config.extra_tag_chinese_sub" />
        <span class="hint">（检测文件名 + 外挂字幕）</span>
      </el-form-item>

      <el-divider content-position="left">水印（打在 poster 和 thumb 左上角）</el-divider>

      <el-form-item label="4K 水印">
        <el-switch v-model="config.watermark_4k" />
      </el-form-item>
      <el-form-item label="8K 水印">
        <el-switch v-model="config.watermark_8k" />
      </el-form-item>
      <el-form-item label="字幕 水印">
        <el-switch v-model="config.watermark_subtitle" />
      </el-form-item>
      <el-form-item label="破解 水印">
        <el-switch v-model="config.watermark_crack" />
      </el-form-item>
      <el-form-item label="流出 水印">
        <el-switch v-model="config.watermark_leak" />
      </el-form-item>
      <el-form-item label="无码 水印">
        <el-switch v-model="config.watermark_uncensored" />
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
  prefer_chinese_source: boolean

  enable_javdb_rating: boolean
  javdb_endpoint: string

  enable_translate: boolean
  translate_engine: string
  translate_deepl_key: string
  translate_bing_key: string
  translate_bing_region: string
  translate_gemini_key: string
  translate_gemini_model: string
  translate_target: string

  extra_tag_resolution: boolean
  extra_tag_uncensored: boolean
  extra_tag_chinese_sub: boolean

  watermark_4k: boolean
  watermark_8k: boolean
  watermark_subtitle: boolean
  watermark_crack: boolean
  watermark_leak: boolean
  watermark_uncensored: boolean
}

const config = ref<AVConfig>({
  enable_metatube: true,
  metatube_server: 'https://metatube-server.hf.space',
  enable_javstash: false,
  javstash_api_key: '',
  prefer_chinese_source: true,

  enable_javdb_rating: false,
  javdb_endpoint: '',

  enable_translate: false,
  translate_engine: 'gemini',
  translate_deepl_key: '',
  translate_bing_key: '',
  translate_bing_region: '',
  translate_gemini_key: '',
  translate_gemini_model: 'gemini-3.8-flash',
  translate_target: 'zh',

  extra_tag_resolution: true,
  extra_tag_uncensored: true,
  extra_tag_chinese_sub: true,

  watermark_4k: true,
  watermark_8k: true,
  watermark_subtitle: true,
  watermark_crack: true,
  watermark_leak: true,
  watermark_uncensored: true,
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
.hint {
  margin-left: 8px;
  color: #999;
  font-size: 12px;
}
</style>
