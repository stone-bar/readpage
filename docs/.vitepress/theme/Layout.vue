<script setup lang="ts">
import { onMounted, ref, watch } from 'vue'
import { withBase } from 'vitepress'

type ReadingMode = 'horizontal' | 'vertical'

const mode = ref<ReadingMode>('horizontal')
const dark = ref(false)
const fontScale = ref(1)

const articleStyle = () => ({
  fontSize: `${1.25 * fontScale.value}rem`,
  writingMode: mode.value === 'vertical' ? 'vertical-rl' : 'horizontal-tb',
  textOrientation: 'mixed'
})

onMounted(() => {
  mode.value = (localStorage.getItem('reader-mode') as ReadingMode) || 'horizontal'
  dark.value = localStorage.getItem('reader-dark') === 'true'
  fontScale.value = Number(localStorage.getItem('reader-font-scale')) || 1
})

watch(mode, (value) => localStorage.setItem('reader-mode', value))
watch(dark, (value) => localStorage.setItem('reader-dark', String(value)))
watch(fontScale, (value) => localStorage.setItem('reader-font-scale', String(value)))

function changeFont(delta: number) {
  fontScale.value = Math.min(1.35, Math.max(0.85, Number((fontScale.value + delta).toFixed(2))))
}
</script>

<template>
  <div class="reader-app" :class="{ 'is-dark': dark }">
    <header class="reader-header">
      <a class="reader-brand" :href="withBase('/')">大字體閱讀器</a>
      <nav class="reader-nav" aria-label="主要導覽">
        <a :href="withBase('/articles/')">文章</a>
        <a :href="withBase('/about')">關於</a>
      </nav>
    </header>

    <div class="reader-toolbar" aria-label="閱讀設定">
      <button type="button" @click="mode = 'horizontal'" :aria-pressed="mode === 'horizontal'">橫排</button>
      <button type="button" @click="mode = 'vertical'" :aria-pressed="mode === 'vertical'">直排</button>
      <span class="toolbar-divider" aria-hidden="true"></span>
      <button type="button" @click="changeFont(-0.1)" aria-label="縮小字體">A−</button>
      <button type="button" @click="changeFont(0.1)" aria-label="放大字體">A＋</button>
      <button type="button" class="dark-toggle" @click="dark = !dark">{{ dark ? '淺色' : '深色' }}</button>
    </div>

    <main class="reader-main" :class="`mode-${mode}`">
      <article class="reader-content" :style="articleStyle()">
        <Content />
      </article>
    </main>
  </div>
</template>