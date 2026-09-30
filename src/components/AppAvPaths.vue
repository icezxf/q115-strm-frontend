const scan = async (id: number) => {
  try {
    const res = await axios.post(`/api/avscrape/paths/${id}/scan`)
    ElMessage.success(res.data.msg || '任务已加入队列')
  } catch (e: any) {
    ElMessage.error(e.response?.data?.error || '添加任务失败')
  }
}