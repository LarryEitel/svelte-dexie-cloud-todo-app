export type TodoItem = {
  id: string;
  realmId: string;
  todoListId: string;
  title: string;
  owner: string;
  done?: boolean;
}
