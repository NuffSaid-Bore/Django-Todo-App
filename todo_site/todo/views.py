from django.shortcuts import render, redirect
from django.contrib import messages
from .models import Todo
from django.utils import timezone


def home(request):
    todos = Todo.objects.all().order_by('-date')
    return render(request, 'todo/home.html', {'todos': todos, 'now': timezone.now(),})


def add_todo(request):
    if request.method == 'POST':
        try:
            Todo.objects.create(
                title=request.POST['title'],
                details=request.POST['details'],
            )
            messages.success(request, "Todo added successfully!")
        except Exception as e:
            messages.error(request, "Failed to add todo.")
    return redirect('home')

def delete_todo(request, todo_id):
    try:
        Todo.objects.get(id=todo_id).delete()
        messages.success(request, "Todo deleted.")
    except:
        messages.error(request, "Failed to delete todo.")
    return redirect('home')
